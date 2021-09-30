//
//  RegisterViewController.swift
//  GProject
//
//  Created by 서정 on 2021/08/25.
//

import UIKit
import RxSwift

class RegisterViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let titleLabel = UILabel()
    let emailTF = UITextField()
    let passwordTF = UITextField()
    let nickNameTF = UITextField()
    //let birthTF = UITextField()
    //let imageField = UIImage()
    
//    private let service : DataServiceType!
//    init(service : DataServiceType = DataService()) {
//        self.service = service
//    }
    let service = DataService()
   
    
    let submitButton = UIButton()
    
    lazy var registerVStack: UIStackView = {
        let stackV = UIStackView(arrangedSubviews: [self.titleLabel, self.emailTF, self.passwordTF, self.nickNameTF, self.submitButton])
        
        stackV.axis = .vertical
        stackV.spacing = 20
        stackV.alignment = .fill
        stackV.distribution = .fillEqually
        return stackV
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setRegisterVStack()
        bindSubmitButton()
        
    }
    
    private func setRegisterVStack() {
        
        titleLabel.text = "회원가입"
        titleLabel.textAlignment = .center
        
        emailTF.borderStyle = .roundedRect
        emailTF.placeholder = "email"
        
        passwordTF.borderStyle = .roundedRect
        passwordTF.placeholder = "password"
        
        nickNameTF.borderStyle = .roundedRect
        nickNameTF.placeholder = "닉네임"
        
        submitButton.setTitle("확인", for: .normal)
        submitButton.titleLabel?.tintColor = .white
        submitButton.layer.cornerRadius = 5
        submitButton.backgroundColor = .black
        
        view.addSubview(registerVStack)
        
        registerVStack.translatesAutoresizingMaskIntoConstraints = false
        registerVStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerVStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        registerVStack.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        
    }
    
    func bindSubmitButton() {
        submitButton.rx.tap
            .bind {
                if let email = self.emailTF.text, let password = self.passwordTF.text, let nickname = self.nickNameTF.text {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let birthString = dateFormatter.string(from: Date())
                    
                    print("EMAIL: ", email)
                    
                    self.service.addUser(userInfo: UserInfo(email: email, password: password, nickname: nickname, birth: birthString))
                    
                    
                }
                self.moveToLoginPage()
            }
            .disposed(by: disposeBag)
            
    }
    

    
    private func moveToLoginPage() {
        self.navigationController?.popViewController(animated: true)
    }

}
