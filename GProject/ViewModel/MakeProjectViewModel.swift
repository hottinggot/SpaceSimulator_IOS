//
//  MakeProjectViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/10/08.
//

import Foundation
import RxSwift

class MakeProjectViewModel {
    
    private let service: DataServiceType!
    init(service: DataServiceType = DataService()) {
        self.service = service
    }
    
    // 매개변수 전달 대신 Relay로 바꿔야함
    func makeProject(id: Int, name: String) -> Observable<Bool> {
        let reqData = ProjectRequestData(projectId: id, projectName: name)
        return service.postProjectInfo(data: reqData)
    }
}
