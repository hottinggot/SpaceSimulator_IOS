//
//  CorrectPasswordViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/10/28.
//

import Foundation
import RxSwift
import RxCocoa

class CorrectPasswordViewModel {
    
    private let service: DataServiceType!
    let disposeBag = DisposeBag()
    
    var validation = false
    
    let passwdTextRelay = BehaviorRelay<String>(value: "")
    let confirmTextRealy = BehaviorRelay<String>(value: "")
    
    init(service: DataServiceType = DataService()) {
        self.service = service
    }
    
    func setValidation() {
        verifyPassword()
            .bind { isValid in
                if isValid {
                    self.validation = true
                } else {
                    self.validation = false
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    private func verifyPassword() -> Observable<Bool> {
        return Observable
            .combineLatest(passwdTextRelay, confirmTextRealy)
            .map { passwd, confirmPasswd in
                if passwd.count > 6 && passwd == confirmPasswd {
                    return true
                } else {
                    return false
                }
            }
    }
    

}
