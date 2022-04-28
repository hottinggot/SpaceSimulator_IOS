//
//  ProjectShareEndpointCases.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Foundation

enum ProjectShareEndpointCases: EndPoint {
    case getShowNeighborProject
    case getDownloadProject
}

extension ProjectShareEndpointCases {
    var httpMethod: String {
        switch self {
        case .getShowNeighborProject:
            return "GET"
        case .getDownloadProject:
            return "GET"
        }
    }
}

extension ProjectShareEndpointCases {
    var baseURLString: String {
        return "http://192.168.0.114:8080"
    }
}

extension ProjectShareEndpointCases {
    var path: String {
        switch self {
        case .getShowNeighborProject:
            return baseURLString + "/neighbor/3/findAll"
        case .getDownloadProject:
            return baseURLString + "/project/1/download"
        }
    }
}

extension ProjectShareEndpointCases {
    var headers: [String : Any]? {
        guard let token = TokenUtils.shared.readJwt()
        else {
            return nil
        }

        return [
            "Content-Type": "application/json",
            "Accept": "*/*",
            "Authorization": "Bearer \(token)"
        ]
    }
}

extension ProjectShareEndpointCases {
    var body: [String : Any]? {
        return [:]
    }
}
