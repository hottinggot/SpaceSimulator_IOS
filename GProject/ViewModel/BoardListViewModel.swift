//
//  BoardListViewModel.swift
//  GProject
//
//  Created by 서정 on 2021/07/15.
//

import Foundation
import RxSwift
import RxCocoa


class BoardListViewModel {
    
    let disposeBag = DisposeBag()
    var boardList = PublishSubject<[Board]>()
    let service = DataService()
    
    var user: UserInfo?
    
    struct Input {
        let click: ControlEvent<Void>
    }
    
    struct TableInput {
        let click: ControlEvent<Board>
    }
 
    func refreshBoardList() {
        service.getBoardList()
            .bind { boardList in
                self.boardList.onNext(boardList)
            }
            .disposed(by: disposeBag)

    }
    
    func bindButton(input: Input, page: UIViewController) {
        input.click.bind {
            self.moveToComposePage(page: page)
        }
        .disposed(by: disposeBag)
    }
    
    func bindTable(input: TableInput, page: UIViewController) {
        input.click
            .subscribe(onNext: { item in
                self.moveToDetailPage(page: page, item: item)
            })
              .disposed(by: disposeBag)
    }
    
    private func moveToComposePage(page: UIViewController) {
        let composePage: ComposeViewController = ComposeViewController()
        composePage.viewModel.mode = .CREATE
        composePage.viewModel.board = Board(title: "", content: "", createdAt: Date().toString(), communityId: 0, nickname: user!.nickname)
        composePage.modalPresentationStyle = .fullScreen
        page.present(composePage, animated: true, completion: nil)
    }
    
    private func moveToDetailPage(page: UIViewController, item: Board) {
        let detailVC = DetailViewController()
        detailVC.viewModel.board = item
        detailVC.viewModel.user = self.user
        page.navigationController!.pushViewController(detailVC, animated: true)
    }
}
