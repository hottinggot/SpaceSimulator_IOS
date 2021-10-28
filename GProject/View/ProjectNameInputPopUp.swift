//
//  ProjectNameInputPopUp.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import UIKit




class ProjectNameInputPopup: UIView {
    
    
    
    var textinput = UITextField()
    
    var confirmBtn = UIButton()
    
    var closeBtn = UIButton()
    
    lazy private var btnstack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [closeBtn,confirmBtn])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy private var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textinput,btnstack])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    var box = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(white: 0, alpha: 0.6)
        makestack()
        makebox()
        
        self.sendSubviewToBack(box)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
extension ProjectNameInputPopup {
    private func makestack(){
        self.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        stack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stack.heightAnchor.constraint(lessThanOrEqualToConstant: 300).isActive = true
        
        
        textinput.backgroundColor = .black
        textinput.textColor = .white
        let attr = NSAttributedString(string: "프로젝트 이름을 입력해주세요", attributes: [.foregroundColor : UIColor.white])
        textinput.attributedPlaceholder = attr
        
        
        btnstack.translatesAutoresizingMaskIntoConstraints = false
        btnstack.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        closeBtn.backgroundColor = .gray
        closeBtn.setTitle("닫기", for:  .normal)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        closeBtn.setTitleColor(.lightGray, for: .normal)
        
        
        confirmBtn.backgroundColor = .systemBlue
        confirmBtn.setTitle("확인", for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        confirmBtn.setTitleColor(.lightGray, for: .normal)
        
        
        
    }
    private func makebox(){
        self.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.topAnchor.constraint(equalTo: stack.topAnchor, constant: -20).isActive = true
        box.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 0).isActive = true
        box.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: 0).isActive = true
        box.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 0).isActive = true
        box.backgroundColor = .black
    }
}
