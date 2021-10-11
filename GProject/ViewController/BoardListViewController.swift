//
//  ListViewController.swift
//  GProject
//
//  Created by 서정 on 2021/07/12.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class BoardListViewController: UIViewController {
    
  
    var collectionView: UICollectionView!

    
    let viewModel = BoardListViewModel()
    let disposeBag = DisposeBag()
    
//    override func viewWillAppear(_ animated: Bool) {
//        viewModel.refreshBoardList()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addCollectionView()
        bindCollectionView()
       
    }
    

    private func addCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        let numberOfCells: CGFloat = 2
        let cellWidth = (UIScreen.main.bounds.width - 30) / numberOfCells
        let cellHeight = cellWidth
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func bindCollectionView() {
        let examples = ["A"]
        let data = Observable.of(examples)
        
        data.bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: CollectionViewCell.self)) { (row, element, cell) in
            cell.backgroundColor = .lightGray
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind { idx in
                if(idx[1]==0) {
                    self.moveToUploadImagePage()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func moveToUploadImagePage() {
        let uploadImagePage: UploadImageViewController = UploadImageViewController()

        uploadImagePage.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(uploadImagePage, animated: true)
    }

}
