//
//  SettingViewController.swift
//  GProject
//
//  Created by 서정 on 2021/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController {
    
    var tableView = UITableView()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addTableView()
        bindTableView()

    }
    
    private func addTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
    }
    
    private func bindTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        Observable.of(["계정 정보 보기", "회원 탈퇴", "로그아웃"]).bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (index:Int, element: String, cell: UITableViewCell) in
            cell.textLabel?.text = element
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind { idx in
                
            }
            .disposed(by: disposeBag)
    }


}
