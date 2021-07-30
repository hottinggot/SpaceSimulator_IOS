//
//  BoradComposeViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift
import RxCocoa

class ComposeViewModel {
    
    var title: String?
    var content: String?
    
    private let service : DataServiceType!
    init(service : DataServiceType = DataService()) {
        self.service = service
    }
    
    let disposeBag = DisposeBag()
    
    var board: Board?
    var mode: ComposeMode?
    
    struct Input {
        let click: ControlEvent<Void>
    }
    struct StringInput {
        let textChange: ControlProperty<String?>
    }
    
    
    enum ComposeMode {
        case CREATE
        case UPDATE
    }
    
    func postComposed() {
        if let title = title, let content = content {
            service.createBoard(title: title, content: content)
        }
    }
    
    func updateBoard(board: Board) {
        var board = board
        if let title = title, let content = content {
            board.title = title
            board.content = content
            service.updateBoard(board: board)
        }
    }
    
    func bindCancelButton(input: Input, vc: UIViewController) {
        input.click
            .bind {
                vc.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    func bindSaveButton(input: Input, vc: UIViewController ) {
        input.click
            .bind {
                if self.mode == .CREATE {
                    self.postComposed()
                } else {
                    self.updateBoard(board: self.board!)
                }
                vc.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    func bindTitleText(input: StringInput) {
        input.textChange
            .bind { (title) in
                self.title = title
            }
            .disposed(by: disposeBag)
    }
    
    func bindContentText(input: StringInput) {
        input.textChange
            .bind { (content) in
                self.content = content
            }
            .disposed(by: disposeBag)
    }
    
}
