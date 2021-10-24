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
    
    init(service: DataServiceType = DataService()) {
        self.service = service
    }
}
