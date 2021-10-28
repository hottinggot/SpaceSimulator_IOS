//
//  SettingViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/10/24.
//

import Foundation
import RxSwift


class SettingViewModel {
    private let service: DataServiceType!
    
    init(service: DataServiceType = DataService()) {
        self.service = service
    }
    
    func withdrawal() -> Observable<Bool> {
        return service.withdrawal()
    }
    
    
}
