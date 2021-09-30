//
//  DataService.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift

enum LoginType {
    case login
    case register
    case kakaoLogin
    case kakaoRegister
}

protocol DataServiceType {
    
    func addUser(userInfo: UserInfo) 
    func loginUser(userInfo: UserInfo) -> Observable<Bool>
    func getMe() -> Observable<UserData>
//    func manageUser(userId: CLong)
//    func deleteUser(userId: CLong)
//    func editUser(userInfo: UserInfo)
    
//    func getAllCities() -> Void
    
//    func createBoard(title: String, content: String)
//
//    @discardableResult
//    func getBoardList(pageNum: Int) -> Observable<[Board]>
//
//    func updateBoard(board: Board)
//
//    func deleteBoard(communityId: Int)

//    func postAccessTokenNUserNickname(accessToken: String, nickname: String, type: LoginType) -> Observable<String>
//    
//    @discardableResult
//    func getUserInfo(jwtToken: String) -> Observable<UserInfo>
    
}
