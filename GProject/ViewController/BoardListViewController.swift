//
//  ListViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/12.
//

import UIKit
import RxSwift

class BoardListViewController: UIViewController {
    
    let composeButton = UIButton()
    let tableView = UITableView()
    let prevButton = UIButton()
    let nextBtn = UIButton()
    lazy var pagingBtnStack: UIStackView = {
        let stackH = UIStackView(arrangedSubviews: [self.prevButton, self.nextBtn])
        stackH.translatesAutoresizingMaskIntoConstraints = false
        stackH.axis = .horizontal
        stackH.spacing = 10
        stackH.alignment = .fill
        stackH.distribution = .fillEqually
        return stackH
    }()
    
    let viewModel = BoardListViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.refreshBoardList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setView()
        bindViewModel()
        bindTableView()
       
    }
    
    private func setView() {
        self.addComposeButton()
        self.addTableView()
        self.addPagingBtnStack()
    }
    
    private func bindViewModel() {
        let composeBtnClick = BoardListViewModel.Input(click: composeButton.rx.tap)
        viewModel.bindButton(input: composeBtnClick, page: self)
    }
    
    private func bindTableView() {
        // 목록 셋팅
        viewModel.boardList.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: TableViewCell.self)) { (index:Int, element: Board, cell: UITableViewCell) in
            cell.textLabel?.text = element.title
        }
        .disposed(by: disposeBag)
        
        // 목록 클릭 이벤트
        let tableViewClick = BoardListViewModel.TableInput(click: tableView.rx.modelSelected(Board.self))
        viewModel.bindTable(input: tableViewClick, page: self)

    }
    
    private func addComposeButton() {
        //set property
        composeButton.setTitle("글쓰기", for: .normal)
        composeButton.setTitleColor(.black, for: .normal)
        
        view.addSubview(composeButton)
        
        //set layout
        composeButton.translatesAutoresizingMaskIntoConstraints = false
        composeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        composeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func addTableView() {
        //set property
        tableView.backgroundColor = .white
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        
        
        //set layout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: composeButton.bottomAnchor, constant: 10).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    private func addPagingBtnStack() {
        //set property
        prevButton.setTitle("이전", for: .normal)
        prevButton.setTitleColor(.gray, for: .normal)
        prevButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        nextBtn.setTitle("다음", for: .normal)
        nextBtn.setTitleColor(.gray, for: .normal)
        nextBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        view.addSubview(pagingBtnStack)
        
        pagingBtnStack.translatesAutoresizingMaskIntoConstraints = false
        pagingBtnStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        pagingBtnStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        pagingBtnStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }

}
