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
    //var boardList = PublishSubject<[Board]>()
    var boardList = BehaviorRelay<[Board]>(value: [])
    
    private let service : DataServiceType!
    init(service : DataServiceType = DataService()) {
        self.service = service
    }
    
    var user: UserInfo?
    var pageNum: Int = 0
    
    struct Input {
        let click: ControlEvent<Void>
    }
    
    struct TableInput {
        let click: ControlEvent<Board>
    }
    
    struct TableScrollInput {
        let scroll: ControlEvent<Void>
    }
 
    func refreshBoardList() {
        self.pageNum = 0
        service.getBoardList(pageNum: pageNum)
            .bind { boardList in
                self.boardList.accept(boardList)
                //self.boardList.onNext(boardList)
            }
            .disposed(by: disposeBag)
    }
    
    func bindButton(input: Input, page: UIViewController) {
        input.click.bind {
            self.moveToComposePage(page: page)
        }
        .disposed(by: disposeBag)
    }
    
    func bindTableClick(input: TableInput, page: UIViewController) {
        input.click
            .subscribe(onNext: { item in
                self.moveToDetailPage(page: page, item: item)
            })
              .disposed(by: disposeBag)
    }
    
    func bindTableScroll(input: TableScrollInput, tableViewSize: Table) {
        input.scroll
            .bind {
                let pagingStandard = tableViewSize.contentHeight - tableViewSize.tableViewHeight
                if pagingStandard + 100 > 0 && tableViewSize.offsetY > pagingStandard - 100 {
                    self.pageNum += 1
                    self.paging(pageNum: self.pageNum)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func paging(pageNum: Int) {
        service.getBoardList(pageNum: pageNum)
            .bind { list in
                let originalList = self.boardList.value
                self.boardList.accept(originalList + list)
            }
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
