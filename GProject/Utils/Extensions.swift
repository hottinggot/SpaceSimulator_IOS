//
//  Extensions.swift
//  IOSAR
//
//  Created by sangmin han on 2021/07/15.
//

import Foundation
import SceneKit
import ARKit


var width : CGFloat = 0.01
var height : CGFloat = 3
var lenght : CGFloat = 1

var doorLength : CGFloat = 0.3

func createdBox(isDoor : Bool) -> SCNNode {
    let node = SCNNode()
    
    
    //box
    let firstbox = SCNBox(width: width , height: height , length: isDoor ? doorLength : lenght, chamferRadius: 0)
    let firstboxNode = SCNNode(geometry: firstbox)
    firstboxNode.renderingOrder = 200 //이게 높을 수록 렌더링 순서 강조가 높아짐
    let image = UIImage(named: "background1")
    firstboxNode.geometry?.firstMaterial?.diffuse.contents = image
    node.addChildNode(firstboxNode)
    
    //outbox
    
    let maskedBox = SCNBox(width: width , height: height , length: isDoor ? doorLength : lenght, chamferRadius: 0)
    maskedBox.firstMaterial?.diffuse.contents = UIColor.white
    maskedBox.firstMaterial?.transparency = 0.00001
    
    let maskedBoxNode = SCNNode(geometry: maskedBox)
    maskedBoxNode.renderingOrder = 100
    maskedBoxNode.position = SCNVector3.init(width, 0, 0)
    
    
//    node.addChildNode(maskedBoxNode)
    
    return node
}

func createdMyBox(isDoor : Bool,length : CGFloat, image : UIImage , color : UIColor? = nil) -> SCNNode {
    let node = SCNNode()
    
    
    //box
    let firstbox = SCNBox(width: width , height: height , length: isDoor ? doorLength : length, chamferRadius: 0)
    let firstboxNode = SCNNode(geometry: firstbox)
    firstboxNode.renderingOrder = 200 //이게 높을 수록 렌더링 순서 강조가 높아짐
    if let color = color {
        firstboxNode.geometry?.firstMaterial?.diffuse.contents = color.cgColor
    }
    else {
        firstboxNode.geometry?.firstMaterial?.diffuse.contents = image
    }
    
    node.addChildNode(firstboxNode)
    
    return node
}




//extension FloatingPoint {
//    var degreesToRadians : Self {
//        return self * .pi / 180
//    }
//
//    var radiansToDegrees : Self {
//        return self * 180 / .pi
//    }
//}



extension CGFloat {
    var clean : Self {
        get {
//            return self
            return CGFloat(Int(self * 1000)) / 1000
        }
        set {
            self = newValue
        }
    }
    
    
    var degreesToRadians : Self {
        if self == 0 {
            return 0
        }
        return self * CGFloat.pi / 180.0
    }
    
    var radiansToDegree: CGFloat {
            return self * CGFloat(180) / .pi
        }
    
    
}

extension CGPoint {
    var clean : Self {
        get {
            
            let x = CGFloat(Int(self.x * 1000)) / 1000
            let y = CGFloat(Int(self.y * 1000)) / 1000
            return CGPoint(x: x, y: y)
            
//            return self
        }
        set {
            self = newValue
        }
    }
}
