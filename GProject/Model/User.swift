//
//  User.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation

struct JWTToken: Codable {
    var token: String
}

struct UserInfo: Codable {
    var nickname: String
    var userId: Int
}
