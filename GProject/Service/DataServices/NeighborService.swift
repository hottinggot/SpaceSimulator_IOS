//
//  NeighborService.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Alamofire
import RxAlamofire
import RxSwift

class NeighborService: Service {
    
    static let shared = NeighborService()
    
    func getSearchNeighbor() {
        let endpoint = NeighborEndpointCases.getSearchNeighbor
        let request = makeRequest(endpoint: endpoint)
    }
    
    func getNeighborList() {
        let endpoint = NeighborEndpointCases.getNeighborList
        let request = makeRequest(endpoint: endpoint)
    }
    
    func postRequestNeighbor() {
        let endpoint = NeighborEndpointCases.postRequestNeighbor
        let request = makeRequest(endpoint: endpoint)
    }
    
    func deleteNeighbor() {
        let endpoint = NeighborEndpointCases.deleteNeighbor
        let request = makeRequest(endpoint: endpoint)
    }
    
    func postApproveNeighbor() {
        let endpoint = NeighborEndpointCases.postApproveNeighbor
        let request = makeRequest(endpoint: endpoint)
    }
    
}
