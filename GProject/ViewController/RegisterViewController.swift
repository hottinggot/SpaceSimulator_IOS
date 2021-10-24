//
//  RegisterViewController.swift
//  GProject
//
//  Created by 서정 on 2021/08/25.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let titleLabel = UILabel()
    let emailTF = UITextField()
    let passwordTF = UITextField()
    let nickNameTF = UITextField()
    
    let birthLabel = UILabel()
    let datePicker = UIDatePicker()

    let viewModel = RegisterViewModel()
    
    let submitButton = UIButton()
    let backButton = UIButton()
    
    lazy var datePickerHStack: UIStackView = {
        let stackH = UIStackView(arrangedSubviews: [self.birthLabel, self.datePicker])
        
        stackH.axis = .horizontal
        stackH.distribution = .fillProportionally
        return stackH
    }()
    
    lazy var registerVStack: UIStackView = {
        let stackV = UIStackView(arrangedSubviews: [self.titleLabel, self.emailTF, self.passwordTF, self.nickNameTF, self.datePickerHStack, self.submitButton, self.backButton])
        
        stackV.axis = .vertical
        stackV.spacing = 20
        stackV.alignment = .fill
        stackV.distribution = .fillProportionally
        return stackV
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setRegisterStack()
        bindViewModel()

    }
    
    private func setRegisterStack() {
        
        titleLabel.text = "회원가입"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "ArialMT", size: 40)
        
        emailTF.borderStyle = .roundedRect
        emailTF.placeholder = "email"
        
        passwordTF.borderStyle = .roundedRect
        passwordTF.placeholder = "password"
        
        nickNameTF.borderStyle = .roundedRect
        nickNameTF.placeholder = "닉네임"
        
        birthLabel.text = "생년월일"
        datePicker.datePickerMode = .date
        
        submitButton.setTitle("확인", for: .normal)
        submitButton.titleLabel?.tintColor = .white
        submitButton.layer.cornerRadius = 5
        submitButton.backgroundColor = .black
        
        backButton.setTitle("취소", for: .normal)
        backButton.titleLabel?.tintColor = .white
        backButton.layer.cornerRadius = 5
        backButton.backgroundColor = .black
        
        view.addSubview(registerVStack)
        
        registerVStack.translatesAutoresizingMaskIntoConstraints = false
        registerVStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerVStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        registerVStack.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        
    }
    
    func bindViewModel() {
        viewModel.setFormValidation()
        
        emailTF.rx.text
            .orEmpty
            .bind(to: viewModel.emailTextRelay)
            .disposed(by: disposeBag)
        
        passwordTF.rx.text
            .orEmpty
            .bind(to: viewModel.passwdTextRealy)
            .disposed(by: disposeBag)
        
        nickNameTF.rx.text
            .orEmpty
            .bind(to: viewModel.nicknameTextRelay)
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .bind(to: viewModel.birthDateRelay)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind {
                if self.viewModel.validation == true {
                    FunctionClass.shared.showdialog(show: true)
                    
                    self.viewModel.submitRegisterInfo()
                        .subscribe(onNext : { [unowned self ] res in
                            if res == true {
                                self.moveBackToLoginPage()
                            }
                            else {
                                // 회원가입 실패
                                // timeout도 처리
                                print("회원가입 실패")
                                ToastView.shared.short(txt_msg: "회원 가입 실패")
                            }
                            FunctionClass.shared.showdialog(show: false)
                        }, onError : { error in
                            ToastView.shared.short(txt_msg: "회원 가입 안됨")
                            FunctionClass.shared.showdialog(show: false)
                        })
                        .disposed(by: self.disposeBag)
                    } else {
                        //입력 형식이 맞지 않음
                        ToastView.shared.short(txt_msg: "입력 형식이 맞지 않음")
                        print("입력 형식이 맞지 않음")
                    }
            }
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind {
                self.moveBackToLoginPage()
            }
            .disposed(by: disposeBag)
    }
    
    
    private func moveBackToLoginPage() {
        self.navigationController?.popViewController(animated: true)
    }

}
