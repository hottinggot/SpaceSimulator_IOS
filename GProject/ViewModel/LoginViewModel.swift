//
//  LoginViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift
import RxCocoa

import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser


class LoginViewModel {

    let disposeBag = DisposeBag()
    let service = DataService()
    
    var accessToken = PublishSubject<String>()
    var userNickname = PublishSubject<String>()
    
    var jwtToken = PublishSubject<String>()
    var userInfo = PublishSubject<UserInfo>()
    
    var validation = PublishSubject<Bool>()
    
    struct Input {
        let click: ControlEvent<Void>
    }
    
    init() {
        // jwtToken 관찰
        self.jwtToken
            .bind { token in
                if token != "" {
                    
                    self.service.getUserInfo(jwtToken: token)
                        .bind {user in
                            print("USER: ", user.nickname)
                            self.userInfo.onNext(user)
                        }
                        .disposed(by: self.disposeBag)
                } else {
                    print("이미 회원가입이 되어있습니다.")
                    self.setValidation(isValid: false)
                }
            }
            .disposed(by: disposeBag)
        
        // userInfo 관찰
        self.userInfo
            .bind {_ in
                self.setValidation(isValid: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindButton(input: Input, type: LoginType) {
        input.click
            .bind {
                
                self.onBind(type: type)
            }
            .disposed(by: disposeBag)
    }
    
    func onBind(type: LoginType) {
        // Kakao api에서 access token과 me를 모두 받았는지 관찰
        Observable.combineLatest(accessToken, userNickname)
            .bind { (token, nickname) in
                // 모두 받았다면 서버에 정보 보냄
                self.service.postAccessTokenNUserNickname(accessToken: token, nickname: nickname, type: type)
                    .bind { jwtToken in
                        
                        //JWT Token을 받았는자 관찰
                        self.jwtToken.onNext(jwtToken)
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by:disposeBag)
        
        // Kakao 요청
        KakaoApi()
    }
        
    func KakaoApi() {
        //카카오 계정으로 로그인, Access token 받아오기
        UserApi.shared.rx.loginWithKakaoAccount().subscribe(onNext:{ (oauthToken) in
                //print("loginWithKakaoAccount() success.")
                self.accessToken.onNext(oauthToken.accessToken)
            }, onError: {error in
                print(error)
            })
            .disposed(by: self.disposeBag)
        
        //내 정보 가져오기
        UserApi.shared.rx.me()
            .subscribe (onSuccess:{ user in
                print("me() success.")

                guard let nickname = user.kakaoAccount?.profile?.nickname else {
                    return
                }
                self.userNickname.onNext(nickname)
                
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func setValidation(isValid: Bool) {
        self.validation.onNext(isValid)
    }
    
    //화면 전환
    func moveToListPage(page: UIViewController, userInfo: UserInfo) {
        let listPage: BoardListViewController = BoardListViewController()
        
        //listPage.user = userInfo
        listPage.viewModel.user = userInfo
        let navigationVC = UINavigationController(rootViewController: listPage)
        listPage.title = "게시글"
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.modalPresentationStyle = .fullScreen
        
        page.present(navigationVC, animated: true, completion: nil)
    }
    
    
    
}
