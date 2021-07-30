//
//  DetailViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/19.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let creatorLabel = UILabel()
    let contentView = UITextView()
    let updateButton = UIButton()
    let deleteButton = UIButton()
    
    lazy var buttonStack: UIStackView = {
        let stackH = UIStackView(arrangedSubviews: [self.updateButton, self.deleteButton])
        stackH.axis = .horizontal
        stackH.spacing = 10
        stackH.alignment = .fill
        stackH.distribution = .fillEqually
        return stackH
    }()
    
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setView()
        setBind()
    }
    
    private func setView() {
        setTitleLabel()
        setDateLabel()
        setCreatorLabel()
        setContentView()
        
        if viewModel.board?.nickname == viewModel.user?.nickname {
            setUpdateButton()
        }
    }
    
    private func setBind() {
        if viewModel.board?.nickname == viewModel.user?.nickname {
            let updateButtonClick = DetailViewModel.Input(click: updateButton.rx.tap)
            viewModel.bindUpdateButton(input: updateButtonClick, page: self)
            
            let deleteButtonClick = DetailViewModel.Input(click: deleteButton.rx.tap)
            viewModel.bindDeleteButton(input: deleteButtonClick, vc: self)
        }
    }
    
    
    private func setTitleLabel() {
        titleLabel.text = viewModel.board?.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
    private func setDateLabel() {
        
    }
    
    private func setCreatorLabel() {
        var creator = "작성자: "
        if let board = viewModel.board {
            creator.append(board.nickname)
        }
        creatorLabel.text = creator
        creatorLabel.font = UIFont.systemFont(ofSize: 13)
        creatorLabel.textColor = .gray
        
        view.addSubview(creatorLabel)
        
        creatorLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        creatorLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        
    }
    
    private func setContentView() {
        contentView.text = viewModel.board?.content
        contentView.font = UIFont.systemFont(ofSize: 15)
        contentView.isUserInteractionEnabled = false
        
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 20).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    private func setUpdateButton() {
        updateButton.setTitle("수정", for: .normal)
        updateButton.backgroundColor = .blue
        updateButton.setTitleColor(.white, for: .normal)
        
        updateButton.layer.masksToBounds = true
        updateButton.layer.cornerRadius = 8
        updateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.backgroundColor = .red
        deleteButton.setTitleColor(.white, for: .normal)
        
        deleteButton.layer.masksToBounds = true
        deleteButton.layer.cornerRadius = 8
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        
        view.addSubview(buttonStack)
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
    }
    
}
