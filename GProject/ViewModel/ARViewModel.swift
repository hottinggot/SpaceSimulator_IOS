//
//  ARViewModel.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import ARKit






class ARViewModel: NSObject {

    //datas
    private var furnitureDatasToPost :  [FurniturePostModel] = []
    
    //input
    var furnitureInput = PublishSubject<(name : String, point : CGPoint)>()
    
    
    
    //output
    struct walls {
        var back : SCNNode
        var left : SCNNode
        var right : SCNNode
        var front : SCNNode
    }
    
    struct walls2Model {
        var wall : [SCNNode]
    }
    
    
    lazy var randomcolors : [UIColor] = {
        var colors : [UIColor] = []
        for _ in 0...200 {
            colors.append(self.getRandomColor())
        }
        
        return colors
    }()
    
    var walls = ReplaySubject<walls>.create(bufferSize: 1)
    var walls2 = BehaviorRelay<walls2Model>.init(value: walls2Model(wall: []))
    var coordinates = BehaviorRelay<[[CGPoint]]>(value: [])
    
    private var service : DataServiceType!
    
    var disposebag = DisposeBag()
    
    weak var coordinator : ViewCoordinator?
    
    
    init(service : DataServiceType = DataService()) {
        
        self.service = service
        super.init()
        furnitureInput
            .subscribe(onNext : { [unowned self] data in
                furnitureDatasToPost.removeAll(where: { $0.name == data.name })
                furnitureDatasToPost.append(FurniturePostModel(name: data.name, x: Double(data.point.x), y: Double(data.point.y)))
               
            })
            .disposed(by: disposebag)
    }
    
    
    
    func getCoordinates() -> Observable<Void> {
        return Observable.create{ [unowned self] seal in
            service.getCoordinates()
                .subscribe(onNext : { [unowned self] data in
                    for coord in data.coordinates {
                        print("coord",coord)
                    }
                    
                    
                    let coordArray = data.coordinates.map{ [CGPoint(x : (($0.0[0]) / 15)  , y : ($0.0[1] / 15) ) ,
                                                            CGPoint(x : (($0.1[0]) / 15) , y : ($0.1[1] / 15) )]}
                    
                    
                    var tempcoord : [[CGPoint]] = []
                    for index in 0...coordArray.count - 1 {
                        tempcoord.append(coordArray[index])
                    }
                    self.coordinates.accept(tempcoord)
                    
                    
//                    let sampledata = [([0,0],[0,-1])]
                    
                    var temp :[([Int],[Int])] = []
                    
                    for index in 0...data.coordinates.count - 1 {
                        temp.append(data.coordinates[index])
                    }
                    self.setUpScene(data: temp)
                    seal.onNext(())
                })
                .disposed(by: disposebag)
            
            return Disposables.create()
        }
    }
    
    
    
    func showObjectSelectionViewController(){
//        coordinator?.showObjectselectionViewController()
    }
    
    private func setUpScene(data : [([Int],[Int])]) {
        
        
        var maxX : CGFloat = CGFloat(data.map{ Double($0.0[0]) }.max() ?? 100.0)
        maxX = maxX <= 1 ? 1 : maxX
        var maxy : CGFloat = CGFloat(data.map{ Double($0.0[1]) }.max() ?? 100.0)
        maxy = maxy <= 1 ? 1 : maxy
        print("maxX",maxX)
        print("maxY",maxy)
        
        let scaleFactor : CGFloat = 10
        var walls : [SCNNode] = []
        
        for (index, coords) in data.enumerated() {
            let firstPoint = CGPoint(x: (CGFloat(coords.0[0]) / maxX) * scaleFactor,
                                     y: (CGFloat(coords.0[1]) / maxy) * scaleFactor).clean
            let lastPoint = CGPoint(x: (CGFloat(coords.1[0]) / maxX) * scaleFactor,
                                    y: (CGFloat(coords.1[1]) / maxy) * scaleFactor).clean
            print("firstpoint",firstPoint)
            print("lastpoint",lastPoint)
            
            let midPoint = self.calculateMidPoint(lhs: firstPoint, rhs: lastPoint)
            print("midPoint",midPoint)
            let length = self.calculateLength(lhs: firstPoint, rhs: lastPoint)
            print("length",length)
            let incline : CGFloat = self.calculateIncline(lhs: firstPoint, rhs: lastPoint)
                //

            print("incline",incline.degreesToRadians)
            let wall = createdMyBox(isDoor: false,length: length,color: randomcolors[index])
            
            //(-0.3 * scaleFactor)
//            wall.simdWorldPosition = simd_float3(Float(midPoint.x - (0.5 * scaleFactor)), 0, Float(midPoint.y - (1 * scaleFactor)))
            wall.worldPosition = SCNVector3.init(midPoint.x - (0.5 * scaleFactor), 0, midPoint.y - (1 * scaleFactor))
//            wall.position = SCNVector3.init(midPoint.x - (0.5 * scaleFactor), (-0.3 * scaleFactor), midPoint.y - (1 * scaleFactor)) // x, y, z
            wall.eulerAngles = SCNVector3.init(0, incline.degreesToRadians, 0)
            
            

            print("======================")
            walls.append(wall)
        }
        
        
        print("walls2 all appended")
        self.walls2.accept(walls2Model(wall: walls))
        
    }
    
}
extension ARViewModel {
    
    
    private func calculateMidPoint(lhs : CGPoint , rhs : CGPoint) -> CGPoint {
        
        let x = (lhs.x + rhs.x)/2
        
        let y = (lhs.y + rhs.y)/2
        
        return CGPoint(x: x, y: y)
    }
    
    private func calculateLength(lhs  : CGPoint, rhs : CGPoint) -> CGFloat {
        
        print("(lhs.x - rhs.x)",(lhs.x - rhs.x))
        print("(lhs.y - rhs.y )",(lhs.y - rhs.y ))
        return sqrt( ((lhs.x - rhs.x)*(lhs.x - rhs.x)) +  ((lhs.y - rhs.y )*(lhs.y - rhs.y)) )
        
    }
    
    func calculateIncline(lhs : CGPoint, rhs : CGPoint) -> CGFloat {
        
        
        let originX = rhs.x - lhs.x
        let originY = rhs.y - lhs.y
        print("originX",originX)
        print("originY",originY)
        
        if abs(originX) <= 0.1 && abs(originY) <= 0.1 {
            if abs(originX) > abs(originY) {
                 return 90
            }
            else {
                return 0
            }
        }
        if abs(originX) <= 0.1  {
            return 0
        }
        if abs(originY) <= 0.1 {
            return 90
        }

        let bearingRadians = atan2f(Float(originY), Float(originX))
        print("bearingRadians",bearingRadians)
        var bearingDegrees = CGFloat(bearingRadians).radiansToDegree
        print("bearingDegrees",bearingDegrees)
//        while bearingDegrees < 0 {
//            bearingDegrees += 360
//        }

        
        return bearingDegrees
    }
    
   
    
    
    
    
    
    
    
    private func findFirstTwoPoint(a : CGFloat, b : CGFloat, c : CGFloat) -> (left : CGPoint, right : CGPoint) {
        
        let s = ( a + b + c) / 2
        let area = sqrt(s*(s-a)*(s-b)*(s-c))
        
        let height = (2*area)/c
        
        let leftpoint = CGPoint(x: -sqrt((a * a) - (height * height)),y: height).clean
        let rightpoint = CGPoint(x: c - abs(leftpoint.x), y: height).clean
        
        return (leftpoint,rightpoint)
    }
    
    
    enum section {
        case quad1
        case quad2
        case quad3
        case quad4
    }
    
    
    private func findPoint(section : section, lastpoint : CGPoint, a : CGFloat, b : CGFloat, c: CGFloat) -> CGPoint{
        
        
        
        let a1 = 4*((lastpoint.x*lastpoint.x) + (lastpoint.y*lastpoint.y))
        let k = (-(lastpoint.x*lastpoint.x) + (-(lastpoint.y*lastpoint.y)) + (c*c) + (-(a*a)))
        let b1 = 4*(lastpoint.y)*k
        let c1 = (k*k) + (-(4*(lastpoint.x*lastpoint.x)*(a*a)))
        
        let y = (-b1 - sqrt((b1*b1) - (4*a1*c1))) / (2*a1)
        
        let x = sqrt((a*a) - (y*y))
        
        
        if section == .quad3 {
            return CGPoint(x: x < 0 ? x : -x, y: y < 0 ? y : -y ).clean
        }
        else if section == .quad4 {
            return CGPoint(x: x < 0 ? -x : x, y: y < 0 ? y : -y ).clean
        }
        else {
            return CGPoint(x: x , y: y ).clean
        }
        
    }
    
    enum direction {
        case back
        case left
        case front
        case right
    }
    
    private func calculateYaw(for direction: direction, incline : CGFloat) -> CGFloat {
        
        switch direction {
        
        case .back:
            return incline.degreesToRadians.clean
        case .left:
            return floor(90 - incline).degreesToRadians.clean
        case .front:
            return floor(90 - incline).degreesToRadians.clean
        case .right:
            return floor(90 - incline).degreesToRadians.clean
        }
        
    }
    
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

    
    
    
    
    
    
    
    
}
