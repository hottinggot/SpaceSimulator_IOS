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
    let viewModel = SettingViewModel()

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
        
        Observable.of(["계정 정보 보기", "비밀번호 변경", "회원 탈퇴", "로그아웃"]).bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (index:Int, element: String, cell: UITableViewCell) in
            cell.textLabel?.text = element
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind { item in
                switch item.item {
                case 0:
                    self.moveToPersonalInfoPage()
                case 1:
                    self.moveToCorrectPasswordPage()
                case 2:
                    self.alertMsgWithdrawal("회원 탈퇴", message: "회원을 탈퇴하시겠습니까?")
//                case 3:
//                    self.alertMsg("로그아웃", message: "로그아웃 하시겠습니까?")
                    
                default:
                    self.alertMsgWithdrawal("회원 탈퇴", message: "회원을 탈퇴하시겠습니까?")
//                    self.alertMsg("다시 시도", message: "다시 시도해주세요")
                }
                    
            
            }
            .disposed(by: disposeBag)
    }
    
    private func moveToPersonalInfoPage() {
        let personalInfoVC = PersonalInfoViewController()
        personalInfoVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(personalInfoVC, animated: true)
    }
    
    private func moveToCorrectPasswordPage() {
        let correctPasswdVC = CorrectPasswordViewController()
        
        correctPasswdVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(correctPasswdVC, animated: true)
        
    }
    
    func alertMsgWithdrawal(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
        let okayAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (action) in
            self.bindWithdrawal()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func bindWithdrawal() {
        self.viewModel.withdrawal()
            .bind { res in
                if res == true {
                    let loginPage: LoginViewController = LoginViewController()
                    
                    let navController = UINavigationController(rootViewController: loginPage)
                        
                    navController.isNavigationBarHidden = true
                    
                    guard let scene = UIApplication.shared.connectedScenes.first else { return }
                    guard let del = scene.delegate as? SceneDelegate else { return }

                    del.window?.rootViewController = navController
                }
            }
            .disposed(by: self.disposeBag)
    }


}
