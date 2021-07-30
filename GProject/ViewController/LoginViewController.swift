//
//  ViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/11.
//

import UIKit
import Alamofire

import RxSwift

import KakaoSDKAuth


class LoginViewController: UIViewController {
    
    var viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    let appNameLabel = UILabel(frame: CGRect())
    let kakaoLoginBtn = UIButton(frame: CGRect())
    let kakaoRegisterBtn = UIButton(frame: CGRect())
    
    var accessToken:OAuthToken?
    var nickname:String?
    
    
    lazy var stackView: UIStackView = {
        let stackV = UIStackView(arrangedSubviews: [self.kakaoLoginBtn, self.kakaoRegisterBtn])
        stackV.axis = .vertical
        stackV.spacing = 20
        stackV.alignment = .fill
        stackV.distribution = .fillEqually
        return stackV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLoginButton()
        bindViewModel()
 
    }
    
    func setLoginButton() {
        // 버튼 이미지 추가
        kakaoLoginBtn.setImage(UIImage(named: "kakao_login_medium_narrow.png"), for: .normal)
        kakaoRegisterBtn.setImage(UIImage(named: "kakao_signup_medium_narrow.png"), for: .normal)
        
        view.addSubview(stackView)
        
        // 레이아웃 추가
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func bindViewModel() {
        
        // 인증 후 화면 전환
        self.viewModel.userInfo
            .bind { user in
                self.viewModel.moveToListPage(page: self, userInfo: user)
            }
            .disposed(by: self.disposeBag)
        
        // 로그인 버튼 클릭
        let loginClick = LoginViewModel.Input(click: kakaoLoginBtn.rx.tap)
        viewModel.bindButton(input: loginClick, type: .LOGIN)
        
        // 회원가입 버튼 클릭
        let registerClick = LoginViewModel.Input(click: kakaoRegisterBtn.rx.tap)
        viewModel.bindButton(input: registerClick, type: .REGISTER)
    }

}

