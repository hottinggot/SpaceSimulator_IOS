//
//  Board.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation


struct ProjectData: Codable {
    var fileDownloadUri: String
    var fileName: String
    var fileType: String
    var imageFileId: Int
    var size: CLong
}

struct ProjectRequestData: Codable {
    var projectId: Int
    var projectName: String
}

struct ProjectResultData: Codable {
    var name: String
    var createdTime: String
}
