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
    
    var projectListBehaviorSubject = BehaviorSubject<[ProjectListObjectData]>(value: [ProjectListObjectData(projectId: 0, projectName: "make", date: "", imageFileUri: "./icon/addImage.png", imageFileId: 0)])
    
    init(service: DataServiceType = DataService()) {
        self.service = service
    }
    
    func getProjectList() {
        service.getAllProject()
            .bind { list in
                self.projectListBehaviorSubject.onNext([ProjectListObjectData(projectId: 0, projectName: "", date: "", imageFileUri: "./icon/addImage.png", imageFileId: 0)] + list)
            }
            .disposed(by: disposeBag)
    }
}
