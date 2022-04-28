//
//  ProjectShareService.swift
//  GProject
//
//  Created by 서정 on 2022/04/27.
//

import Alamofire
import RxAlamofire
import RxSwift

class ProjectShareService: Service {
    
    static let shared = ProjectShareService()
    
    func getShowNeighborProject() {
        let endpoint = ProjectShareEndpointCases.getShowNeighborProject
        let request = makeRequest(endpoint: endpoint)
    }
    
    func getDownloadProject() {
        let endpoint = ProjectShareEndpointCases.getDownloadProject
        let request = makeRequest(endpoint: endpoint)
    }
}
