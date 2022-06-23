//
//  SettingViewController.swift
//  GProject
//
//  Created by 서정 on 2021/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

enum DarkMode {
    case lightMode
    case darkMode
}

class SettingViewController: BaseViewController {
    
    let backButton = UIButton()
        .then {
            $0.setImage(UIImage(named: "Back")?.resizedImage(size: CGSize(width: 8, height: 14)), for: .normal)
        }
    
    let titleLabel = UILabel()
        .then {
            $0.text = "Setting"
            $0.textColor = UIColor.textColor
            $0.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        }
    
    let tableView = UITableView()
        .then {
            $0.backgroundColor = .clear
        }
    
    var disposeBag = DisposeBag()
    let viewModel = SettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        addView()
        bindView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func addView() {
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20.0)
            $0.top.equalToSuperview().offset(70.0)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(backButton.snp.right).offset(20.0)
            $0.centerY.equalTo(backButton.snp.centerY)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(30.0)
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-20.0)
            $0.bottom.equalToSuperview().offset(-30.0)
        }
        
    }
    
    private func bindView() {
        backButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        Observable.of(["다크모드","계정 정보 보기", "비밀번호 변경", "회원 탈퇴", "로그아웃", "앱 초기화"]).bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (index:Int, element: String, cell: UITableViewCell) in
            cell.selectionStyle = .none
            cell.textLabel?.text = element
            cell.textLabel?.textColor = UIColor.textColor
            cell.backgroundColor = .clear
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind { [weak self] item in
                switch item.item {
                case 0:
                    //다크모드
                    self?.setDarkMode()
                    break
                    
                case 1:
                    //계정 정보 보기
                    self?.moveToPersonalInfoPage()
                    break
                    
                case 2:
                    //비밀번호 변경
                    self?.moveToCorrectPasswordPage()
                    break
                    
                case 3:
                    //회원 탈퇴
                    self?.alertMsgWithdrawal("회원 탈퇴", message: "회원을 탈퇴하시겠습니까?")
                    break
                    
                case 4:
                    //로그아웃
                    self?.alertMsgWithdrawal("로그아웃", message: "로그아웃 하시겠습니까?")
                    break
                    
                case 5:
                    //앱 초기화
                    break
                    
                default:
                    self?.alertMsgWithdrawal("다시 시도", message: "다시 시도해주세요")
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setDarkMode() {
        print("다크모드 설정1 \(UserDefaults.standard.string(forKey: "Appearance")  ?? "Err") ")
        if self.overrideUserInterfaceStyle == .light {
            UserDefaults.standard.set("Dark", forKey: "Appearance")
        } else {
            UserDefaults.standard.set("Light", forKey: "Appearance")
        }
        print("다크모드 설정2 \(UserDefaults.standard.string(forKey: "Appearance")  ?? "Err2") ")
        
        self.viewWillAppear(true)
        
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
