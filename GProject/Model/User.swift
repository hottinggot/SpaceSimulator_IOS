//
//  User.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation


struct UserInfo: Codable {
    var email: String
    var password: String
    var nickname: String
    var birth: String
}

struct UserId: Codable {
    var id: CLong
}

struct RegisterResponse: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: UserData
}

struct UserData: Codable {
    var email: String
    var nickname: String
    var birth: String
    var authorities: [AuthorityName]
}

struct AuthorityName: Codable {
    var authorityName: String
}

struct LoginResponseData: Codable {
    var statusCode: Int
    var responseMessage: String
    var data: JWTToken
}

struct JWTToken: Codable {
    var token: String
}
