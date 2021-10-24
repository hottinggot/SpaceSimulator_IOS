//
//  ToastView.swift
//  Jammi
//
//  Created by 한상민 on 23/03/2019.
//  Copyright © 2019 shot. All rights reserved.
//
import Foundation
import UIKit

open class ToastView: UILabel {
    
    var overlayView = UIView()
    var backView = UIView()
    var lbl = UILabel()
    let customcolor = UIColor.darkGray
    
    public enum pos {
        case center
        case bottom
    }
    
    class var shared: ToastView {
        struct Static {
            static let instance: ToastView = ToastView()
        }
        return Static.instance
    }
    
    func setupcenterView(_ view: UIView,txt_msg:String)
    {
        //let white = UIColor ( red: 1/255, green: 0/255, blue:0/255, alpha: 0.0 )
        
        
        backView.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        backView.center = view.center
        backView.backgroundColor = .clear
        backView.alpha = 0
        view.addSubview(backView)
        
        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60  , height: 50)
        overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        overlayView.backgroundColor = UIColor.red
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.alpha = 0
        
        lbl.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width, height: 50)
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.white
        lbl.center = overlayView.center
        lbl.text = txt_msg
        lbl.backgroundColor = customcolor
        lbl.textAlignment = .center
        lbl.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(lbl)
        
        view.addSubview(overlayView)
    }
    
    func setupbottomView(_ view : UIView , txt_msg : String){
        backView.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        backView.center = view.center
        backView.backgroundColor = .clear
        backView.alpha = 0
        view.addSubview(backView)
        
        overlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 60  , height: 50)
        overlayView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 100)
        overlayView.backgroundColor = UIColor.red
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.alpha = 0
        
        lbl.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width, height: 50)
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.white
        lbl.center = overlayView.center
        lbl.text = txt_msg
        lbl.backgroundColor = customcolor
        lbl.textAlignment = .center
        lbl.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        overlayView.addSubview(lbl)
        
        view.addSubview(overlayView)
    }
//
//    open func short(_ view: UIView,txt_msg:String ) {
//        self.setup(view,txt_msg: txt_msg)
//        //Animation
//        UIView.animate(withDuration: 1, animations: {
//            self.overlayView.alpha = 1
//        }) { (true) in
//            UIView.animate(withDuration: 1, animations: {
//                self.overlayView.alpha = 0
//            }) { (true) in
//                UIView.animate(withDuration: 1, animations: {
//                    DispatchQueue.main.async(execute: {
//                        self.overlayView.alpha = 0
//                        self.lbl.removeFromSuperview()
//                        self.overlayView.removeFromSuperview()
//                        self.backView.removeFromSuperview()
//                    })
//                })
//            }
//        }
//    }
    
    open func short(txt_msg:String,post : pos = .bottom) {
        let scene = UIApplication.shared.connectedScenes.first
        guard let del = scene?.delegate as? SceneDelegate else { return }
        
        if post == .bottom {
            self.setupbottomView(del.window!,txt_msg: txt_msg)
        }
        else {
            self.setupcenterView(del.window!, txt_msg: txt_msg)
        }
        
        //Animation
        UIView.animate(withDuration: 1, animations: {
            self.overlayView.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
                self.overlayView.alpha = 0
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    DispatchQueue.main.async(execute: {
                        self.overlayView.alpha = 0
                        self.lbl.removeFromSuperview()
                        self.overlayView.removeFromSuperview()
                        self.backView.removeFromSuperview()
                    })
                })
            }
        }
    }
    
//    open func long(_ view: UIView,txt_msg:String) {
//        self.setup(view,txt_msg: txt_msg)
//        //Animation
//        UIView.animate(withDuration: 2, animations: {
//            self.overlayView.alpha = 1
//        }) { (true) in
//            UIView.animate(withDuration: 2, animations: {
//                self.overlayView.alpha = 0
//            }) { (true) in
//                UIView.animate(withDuration: 2, animations: {
//                    DispatchQueue.main.async(execute: {
//                        self.overlayView.alpha = 0
//                        self.lbl.removeFromSuperview()
//                        self.overlayView.removeFromSuperview()
//                        self.backView.removeFromSuperview()
//                    })
//                })
//            }
//        }
//    }
}


class ImageProgressAnimator : UIView {
    
    class var shared: ImageProgressAnimator {
        struct Static {
            static let instance: ImageProgressAnimator = ImageProgressAnimator()
        }
        return Static.instance
    }
    
    private var backgroundview : UIView?
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var label = UILabel()
    
    
    
    private func setup() {
        if let _ = backgroundview {

            return
        }
        else {
            backgroundview = UIView()
            guard let scene = UIApplication.shared.connectedScenes.first else { return }
            guard let del = scene.delegate as? SceneDelegate else { return }
            del.window?.addSubview(backgroundview!)
            backgroundview!.frame = del.window!.frame
            backgroundview!.backgroundColor = .init(white: 0, alpha: 0.4)
            createCircularPath()
            let midx = backgroundview!.frame.midX
            let midy = backgroundview!.frame.midY
            label.frame = CGRect(x: midx - 25, y: midy - 25, width: 50, height: 50)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.textColor = .init(white: 0.7, alpha: 1)
            backgroundview?.addSubview(label)
            
        }
    }
    
    func createCircularPath() {
        //let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0), radius: 68, startAngle: -.pi / 2, endAngle: -.pi / 2 + .pi / 180, clockwise: false)
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: backgroundview!.bounds.size.width / 2.0, y: backgroundview!.bounds.size.height / 2.0), radius: 50, startAngle: -.pi / 2, endAngle: .pi * 3 / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.gray.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 5
        //circleLayer.strokeColor = UIColor.rgb(red: 230, green: 230, blue: 230, alpha: 1).cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 5.0
        progressLayer.strokeEnd = 0
        //progressLayer.strokeColor = UIColor.rgb(red: 255, green: 158, blue: 152, alpha: 1).cgColor
        progressLayer.strokeColor = UIColor.gray.cgColor
        
        backgroundview!.layer.addSublayer(circleLayer)
        backgroundview!.layer.addSublayer(progressLayer)
    }

    func progressAnimation(toValue : Double) {
        setup()
        progressLayer.strokeEnd = CGFloat(toValue)
        label.text = "\(Int(toValue * 100))%"
//        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        circularProgressAnimation.duration = 10
//        circularProgressAnimation.fromValue = 0
//        circularProgressAnimation.toValue = toValue
//        circularProgressAnimation.fillMode = .forwards
//
//
//        circularProgressAnimation.isRemovedOnCompletion = false
//
//
//        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    
    func endAnimation(){
        self.backgroundview?.removeFromSuperview()
        self.backgroundview = nil
        self.circleLayer.removeFromSuperlayer()
        self.progressLayer.removeFromSuperlayer()
    }
    
}




