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
    
    var projectListBehaviorSubject = BehaviorRelay<[ProjectListObjectData]>(value: [ProjectListObjectData(projectId: 0, name: "make", date: "", imageFileUri: "icListEmptyWork", imageFileId: 0)])
    
    init(service: DataServiceType = DataService()) {
        self.service = service
        getProjectList()
    }
    
    func getProjectList() {
        service.getAllProject()
            .bind { list in
                
                self.projectListBehaviorSubject.accept([ProjectListObjectData(projectId: 0, name: "", date: "", imageFileUri: "icListEmptyWork", imageFileId: 0)] + list)
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    func getProjectId(index : Int) -> Int {
        return projectListBehaviorSubject.value[index].projectId
    }
}
