//
//  PersonalInfoViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/10/24.
//

import Foundation
import RxSwift
import RxCocoa

class PersonalInfoViewModel {
    
    private let service: DataServiceType!
    let disposeBag = DisposeBag()
    
    var infoSubject = BehaviorSubject<[String]>(value: [])
    
    init(service: DataServiceType = DataService()) {
        self.service = service
    }
    
    func getMyInfo() {
        service.getMe()
            .bind { userData in
                var list: [String] = []
                list.append("이메일: \(userData.email)")
                list.append("닉네임: \(userData.nickname)")
                list.append("생일: \(userData.birth)")
                
                self.infoSubject.onNext(list)
                
            }
            .disposed(by: disposeBag)
        
    }
}
