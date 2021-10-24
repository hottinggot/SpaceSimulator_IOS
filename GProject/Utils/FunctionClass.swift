//
//  FunctionClass.swift
//  CarpumUser
//
//  Created by 한상민 on 05/08/2019.
//  Copyright © 2019 shot. All rights reserved.
//

import Foundation
import UIKit

class FunctionClass {
    var spinner : IndicatorView!
    static let shared = FunctionClass()
    private init(){
        guard let scene = UIApplication.shared.connectedScenes.first else { return }
        guard let del  = scene.delegate as? SceneDelegate else { return }
        spinner = IndicatorView(frame: del.window!.frame)
        del.window?.addSubview(spinner)
        
    }
    
    func showdialog(show : Bool){
        guard let scene = UIApplication.shared.connectedScenes.first else { return }
        guard let del  = scene.delegate as? SceneDelegate else { return }
        DispatchQueue.main.async { [unowned self] in
            if show {
                del.window?.bringSubviewToFront(spinner)
                spinner.setvisibilitySpinner(status: true)
            }
            else {
                spinner.alpha = 0
                spinner.setvisibilitySpinner(status: false)
            }
        }
        
    
    }
    
}

class IndicatorView : UIView {
    
    private var spinner = UIActivityIndicatorView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
        makespinner()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setvisibilitySpinner(status: Bool) {
        
        if status == true
        {
            spinner.startAnimating()
        }
        else{
            spinner.stopAnimating()
        }
    }
    
    func makespinner(){
        self.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 100).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 100).isActive = true
        spinner.tintColor = .black
        spinner.contentMode = .scaleToFill
        spinner.style = .large
        spinner.color = .black
        
    }
}
