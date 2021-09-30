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
    
    private let service : DataServiceType!
    
    var accessToken = PublishSubject<String>()
    var userNickname = PublishSubject<String>()
    
    var requestingUser = UserInfo(email: "", password: "", nickname: "", birth: "")

    var userData = PublishSubject<UserData>()
    
    var validation = false
    
    let emailTextRelay = BehaviorRelay<String>(value: "")
    let passwdTextRealy = BehaviorRelay<String>(value: "")
    
    
    struct Input {
        let click: ControlEvent<Void>
    }
    
    struct FormInput {
        let change: ControlProperty<String?>
    }
    
    init(service : DataServiceType = DataService()) {
        self.service = service
 
    }
    
    func setFormValidation() {
        isFormValid()
            .bind { v in
                self.validation = v
            }
            .disposed(by: disposeBag)
    }
    
    private func isFormValid() -> Observable<Bool> {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return Observable
            .combineLatest(emailTextRelay, passwdTextRealy)
            .map { email, passwd in
                if emailTest.evaluate(with: email) && passwd.count > 6 {
                    self.requestingUser.email = email
                    self.requestingUser.password = passwd
                    return true
                } else {
                    return false
                }
            }
    }
    
    func requestLogin() {
        
        service.loginUser(userInfo: requestingUser)
            .bind { res in
                if res {
                    self.service.getMe()
                        .bind { user in
                            self.userData.onNext(user)
                        }
                        .disposed(by: self.disposeBag)
                    
                }
            }
            .disposed(by: disposeBag)

    }
    
   
    
    private func onBind(type: LoginType, userInfo: UserInfo) {
//        switch type {
//        case .login:
//            //원래 서비스에 userInfo 보내어 응답 받아야 함
//            if validateForm(userInfo: userInfo) {
//                self.userInfo.onNext(userInfo)
//            } else {
//                print("validation false")
//            }
//            
//        default:
//            print("not a login type")
//        }
        
//        switch type {
//        case .register:
//            service.addUser(userInfo: userInfo)
//        default:
//            <#code#>
//        }
        // Kakao api에서 access token과 me를 모두 받았는지 관찰
//        Observable.combineLatest(accessToken, userNickname)
//            .bind { (token, nickname) in
//                // 모두 받았다면 서버에 정보 보냄
//                self.service.postAccessTokenNUserNickname(accessToken: token, nickname: nickname, type: type)
//                    .bind { jwtToken in
//
//                        //JWT Token을 받았는자 관찰
//                        self.jwtToken.onNext(jwtToken)
//                    }
//                    .disposed(by: self.disposeBag)
//            }
//            .disposed(by:disposeBag)
//
//        // Kakao 요청
//        KakaoApi()
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
    
    
    
}
