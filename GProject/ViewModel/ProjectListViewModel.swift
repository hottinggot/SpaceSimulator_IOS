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
    
    var projectListBehaviorSubject = BehaviorRelay<[ProjectListObjectData]>(value: [ProjectListObjectData(projectId: -1, name: "", date: "", imageFileUri: imageIconName, imageFileId: -1)])
    
    func getProjectList() {
        ProjectService.shared.getShowProjectList()
            .bind { [weak self] response in
                
                self?.projectListBehaviorSubject.accept([ProjectListObjectData(projectId: -1, name: "", date: "", imageFileUri: imageIconName, imageFileId: -1)] + (response.data ?? []))
            }
            .disposed(by: disposeBag)
    }
    
    func getProjectId(index : Int) -> Int {
        return projectListBehaviorSubject.value[index].projectId ?? 0
    }
}
