//
//  PersonalInfoViewController.swift
//  GProject
//
//  Created by 서정 on 2021/10/24.
//

import UIKit
import RxSwift

class PersonalInfoViewController: BaseViewController {

    let viewModel = PersonalInfoViewModel()
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.backgroundColor
        
        addTableView()
        bindView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func bindView() {
        viewModel.getMyInfo()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        viewModel.infoSubject
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (index:Int, element: String, cell: UITableViewCell) in
                cell.textLabel?.textColor = UIColor.textColor
                cell.textLabel?.text = element
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
