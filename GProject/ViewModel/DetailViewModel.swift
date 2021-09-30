////
////  BoardDetailViewModel.swift
////  GProject
////
////  Created by 서정 on 2021/07/15.
////
//
//import Foundation
//import RxCocoa
//import RxSwift
//
//class DetailViewModel {
//    
//    var board: Board?
//    var user: UserInfo?
//    
//    private let service : DataServiceType!
//    init(service : DataServiceType = DataService()) {
//        self.service = service
//    }
//    let disposeBag = DisposeBag()
//    
//    struct Input {
//        let click: ControlEvent<Void>
//    }
//    
//    func bindUpdateButton(input: Input, page: UIViewController) {
//        input.click
//            .bind {
//                self.moveToComposeView(page: page)
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    func bindDeleteButton(input: Input, vc: UIViewController) {
//        input.click
//            .bind {
//                self.deleteBoard(board: self.board!)
//                vc.navigationController?.popViewController(animated: true)
//            }
//            .disposed(by: disposeBag)
//    }
//    
////    private func deleteBoard (board: Board) {
////        service.deleteBoard(communityId: board.communityId)
////    }
//    
//    private func moveToComposeView(page: UIViewController) {
//        let composeVC = ComposeViewController()
//        composeVC.viewModel.mode = .UPDATE
//        composeVC.viewModel.board = self.board
//        composeVC.modalPresentationStyle = .fullScreen
//        page.present(composeVC, animated: true, completion: nil)
//    }
//}
