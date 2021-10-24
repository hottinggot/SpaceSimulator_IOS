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

class ProjectListViewController: UIViewController {
    
  
    var collectionView: UICollectionView!
    
    let viewModel = ProjectListViewModel()
    let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addCollectionView()
        bindCollectionView()
        bindLeftNavButton()
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
        
        viewModel.projectListBehaviorSubject
            .bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: CollectionViewCell.self)) { (index: Int, element: ProjectListObjectData, cell: CollectionViewCell)  in
                
                cell.backgroundColor = .lightGray
               
                let imageData = try? Data(contentsOf: URL(string: element.imageFileUri)!)
                
                if let imageData = imageData {
                    cell.imageView.image = UIImage(data: imageData)
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind { idx in
                if(idx[1]==0) {
                    let view = ImageListViewController()
                    self.navigationController?.pushViewController(view, animated: true)
//                    self.moveToUploadImagePage()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func moveToUploadImagePage() {
        let uploadImagePage: UploadImageViewController = UploadImageViewController()

        uploadImagePage.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(uploadImagePage, animated: true)
    }
    
    private func bindLeftNavButton() {
        self.navigationItem.leftBarButtonItem?
            .rx.tap
            .bind { _ in
                self.moveToSettingVC()
            }
            .disposed(by: disposeBag)    }
    
    private func moveToSettingVC() {
        let settingPage = SettingViewController()
        settingPage.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(settingPage, animated: true)
    }
    
}
