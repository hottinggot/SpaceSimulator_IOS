//
//  ProjectListViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift
import RxCocoa


class ProjectListViewModel {
    let disposeBag = DisposeBag()
    private let service: DataServiceType!
    
    var projectListBehaviorSubject = BehaviorRelay<[ProjectListObjectData]>(value: [ProjectListObjectData(projectId: -1, name: "", date: "", imageFileUri: imageIconName, imageFileId: -1)])
    
    
    init(service: DataServiceType = DataService()) {
        self.service = service
//        getProjectList()
    }
    
    func getProjectList() {
        service.getAllProject()
            .bind { list in
                
                self.projectListBehaviorSubject.accept([ProjectListObjectData(projectId: -1, name: "", date: "", imageFileUri: imageIconName, imageFileId: -1)] + list)
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    func getProjectId(index : Int) -> Int {
        return projectListBehaviorSubject.value[index].projectId
    }
}
