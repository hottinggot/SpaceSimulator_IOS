//
//  NeighborEndpointCases.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Foundation

enum NeighborEndpointCases: EndPoint {
    case getSearchNeighbor
    case getNeighborList
    case postRequestNeighbor
    case deleteNeighbor
    case postApproveNeighbor
}

extension NeighborEndpointCases {
    var httpMethod: String {
        switch self {
        case .getSearchNeighbor:
            return "GET"
        case .getNeighborList:
            return "GET"
        case .postRequestNeighbor:
            return "POST"
        case .deleteNeighbor:
            return "DELETE"
        case .postApproveNeighbor:
            return "POST"
        }
    }
}

extension NeighborEndpointCases {
    var baseURLString: String {
        return "http://192.168.0.114:8080/neighbor"
    }
}

extension NeighborEndpointCases {
    var path: String {
        switch self {
        case .getSearchNeighbor:
            return baseURLString + "/nick/search"
        case .getNeighborList:
            return baseURLString + "/findAll"
        case .postRequestNeighbor:
            return baseURLString + "/request"
        case .deleteNeighbor:
            return baseURLString + "/1/delete"
        case .postApproveNeighbor:
            return baseURLString + "/approve"
        }
    }
}

extension NeighborEndpointCases {
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

extension NeighborEndpointCases {
    var body: [String : Any]? {
        switch self {
        case .postRequestNeighbor:
            return [:]
        case .postApproveNeighbor:
            return [:]
        default: return [:]
        }
    }
}
