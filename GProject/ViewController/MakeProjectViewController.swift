//
//  MakeProjectViewController.swift
//  GProject
//
//  Created by 서정 on 2021/10/08.
//

import UIKit
import RxSwift

class MakeProjectViewController: UIViewController {
    
    var nameTextField = UITextField()
    var makeProjectButton = UIButton()
    var id: Int?
    
    let viewModel = MakeProjectViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addTextField()
        addMakeProjectButton()

        // Do any additional setup after loading the view.
    }
    
    private func addTextField() {
        nameTextField.borderStyle = .roundedRect
        nameTextField.font = UIFont(name: "ArialMT", size: 40)
        view.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 2/3).isActive = true
                
    }
    
    private func addMakeProjectButton() {
        makeProjectButton.backgroundColor = .lightGray
        makeProjectButton.setTitle("Make project", for: .normal)
        makeProjectButton.layer.cornerRadius = 5
        makeProjectButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        view.addSubview(makeProjectButton)
        
        makeProjectButton.translatesAutoresizingMaskIntoConstraints = false
        makeProjectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        makeProjectButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        
        makeProjectButton.rx.tap
            .bind {
                if let id = self.id, let name = self.nameTextField.text {
                    self.viewModel.makeProject(id: id, name: name)
                        .bind { res in
                            if res == true {
                                self.navigationController?.popToRootViewController(animated: false)
                            }
                        }
                        .disposed(by: self.disposeBag)
                }
                else {
                    // 프로젝트 생성 실패
                    print("failed")
                }
            }
            .disposed(by: disposeBag)
    }
    


}
