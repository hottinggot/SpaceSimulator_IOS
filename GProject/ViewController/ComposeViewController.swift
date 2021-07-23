//
//  ComposeViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/19.
//

import UIKit
import RxSwift

class ComposeViewController: UIViewController {
    
    
    let titleView = UITextField()
    let contentView = UITextView()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    lazy var buttonStack: UIStackView = {
        let stackH = UIStackView(arrangedSubviews: [self.saveButton, self.cancelButton])
        stackH.translatesAutoresizingMaskIntoConstraints = false
        stackH.axis = .horizontal
        stackH.spacing = 10
        stackH.alignment = .fill
        stackH.distribution = .fillEqually
        return stackH
    }()
    
    let viewModel = ComposeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setView()
        setBind()
        
        let titleChange = ComposeViewModel.StringInput(textChange: titleView.rx.text)
        viewModel.bindTitleText(input: titleChange)
        
        let contentChange = ComposeViewModel.StringInput(textChange: contentView.rx.text)
        viewModel.bindContentText(input: contentChange)
        
    }

    private func setView() {
        setTitleView()
        setContentView()
        setButton()
        
        setTitleViewProperty()
        setContentViewProperty()
    }
    
    private func setBind() {
        let cancelButtonClick = ComposeViewModel.Input(click: cancelButton.rx.tap)
        viewModel.bindCancelButton(input: cancelButtonClick, vc: self)
        
        let saveButtonClick = ComposeViewModel.Input(click: saveButton.rx.tap)
        viewModel.bindSaveButton(input: saveButtonClick, vc: self)
        
    }
    
    private func setTitleViewProperty() {
        if(viewModel.board?.title == "") {
            titleView.attributedPlaceholder = NSAttributedString(string: "제목", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        } else {
            titleView.text = viewModel.board?.title
        }
        
        titleView.font = UIFont.boldSystemFont(ofSize: 30)
        titleView.isUserInteractionEnabled = true
    }
    
    private func setTitleView() {
        
        view.addSubview(titleView)
        
        //set layout
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -20).isActive = true
        titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
    }
    
    private func setContentViewProperty() {
        contentView.text = viewModel.board?.content
        contentView.font = UIFont.systemFont(ofSize: 18)
    }
    
    private func setContentView() {
    
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        contentView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -20).isActive = true
        contentView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        
    }
    
    private func setButton() {
        saveButton.backgroundColor = .purple
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 8
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        cancelButton.backgroundColor = .red
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 8
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        view.addSubview(buttonStack)
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    

}
