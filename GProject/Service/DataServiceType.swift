//
//  DataService.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift
import Alamofire

enum LoginType {
    case login
    case register
    case kakaoLogin
    case kakaoRegister
}

protocol DataServiceType {
    
    func addUser(userInfo: UserInfo) -> Observable<Bool>
    func loginUser(userInfo: UserInfo) -> Observable<Bool>
    func getMe() -> Observable<UserData>
    
    func postImage(imageData: Data) -> Observable<Int>
    
    // 일단은 Bool로 하고 나중에 수정..
    func postProjectInfo(data: ProjectRequestData) -> Observable<Bool>
    
    func getAllProject() -> Observable<[ProjectListObjectData]>
    
}
