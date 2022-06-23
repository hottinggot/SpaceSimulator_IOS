//
//  CorrectPasswordViewController.swift
//  GProject
//
//  Created by 서정 on 2021/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class CorrectPasswordViewController: BaseViewController {

    let viewModel = CorrectPasswordViewModel()
    let disposeBag = DisposeBag()
    
    let titleLabel = UILabel()
    let passwordField = UITextField()
    let confirmField = UITextField()
    let button = UIButton()

    
    
    lazy var vStackView: UIStackView = {
        let stackV = UIStackView(arrangedSubviews: [self.titleLabel, self.passwordField, self.confirmField, self.button])
        
        stackV.spacing = 10
        stackV.axis = .vertical
        stackV.distribution = .fillProportionally
        
        return stackV
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        makeView()
        bindView()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func makeView() {
        titleLabel.text = "비밀번호 변경"
        passwordField.placeholder = "새 비밀번호"
        confirmField.placeholder = "비밀번호 확인"
        passwordField.borderStyle = .roundedRect
        confirmField.borderStyle = .roundedRect
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        
        view.addSubview(vStackView)
        
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        vStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        vStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        vStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
    }
    
    func bindView() {
        passwordField.rx.text
            .orEmpty
            .bind(to: viewModel.passwdTextRelay)
            .disposed(by: disposeBag)
        
        confirmField.rx.text
            .orEmpty
            .bind(to: viewModel.confirmTextRealy)
            .disposed(by: disposeBag)
        
        viewModel.setValidation()
        
        button.rx.tap
            .bind{ _ in
                if self.viewModel.validation == true {
//                    self.viewModel.requestChangePasswd()
                }
                else {
                    print("비밀번호 형식에 맞지 않음.")
                }
            }
            .disposed(by: disposeBag)
    }

}
