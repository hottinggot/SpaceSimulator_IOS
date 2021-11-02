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
    
  
    let coordinator = ViewCoordinator()
    
    let viewModel = ProjectListViewModel()
    let disposeBag = DisposeBag()
    
    lazy var projectCV : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let leftBtnItem = UIBarButtonItem()
        leftBtnItem.title = "내 정보"
        leftBtnItem.tintColor = .black
        
        let rightBtnItem = UIBarButtonItem()
        rightBtnItem.title = "선택"
        rightBtnItem.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = leftBtnItem
        self.navigationItem.rightBarButtonItem = rightBtnItem
        
        addCollectionView()
        bindCollectionView()
        bindLeftNavButton()
    }
    

    private func addCollectionView() {

        if let layout = projectCV.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let numberOfCells: CGFloat = 2
            let cellWidth = (UIScreen.main.bounds.width - 30) / numberOfCells
            let cellHeight = cellWidth
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            
        }
        
        view.addSubview(projectCV)
        
        projectCV.translatesAutoresizingMaskIntoConstraints = false
        projectCV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        projectCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        projectCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        projectCV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        projectCV.backgroundColor = .systemFill
        projectCV.layer.cornerRadius = 15
    }
    
    private func bindCollectionView() {
        
        viewModel.projectListBehaviorSubject
            .bind(to: projectCV.rx.items(cellIdentifier: "Cell", cellType: CollectionViewCell.self)) { (index: Int, element: ProjectListObjectData, cell: CollectionViewCell)  in
                
                cell.backgroundColor = .none
                cell.titleLabel.text = element.name
                if element.imageFileUri == imageIconName {
                    cell.imageView.image = UIImage(named: imageIconName)
                    
                }
                else {
                    if let url = URL(string: element.imageFileUri) {
                        cell.imageView.kf.setImage(with: url)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        projectCV.rx.modelSelected(ProjectListObjectData.self)
            .subscribe(onNext : { [unowned self] model in
                if model.imageFileId == -1 || model.projectId == -1 {
                    let view = ImageListViewController()
                    self.navigationController?.pushViewController(view, animated: true)
                }
                else {
                    coordinator.start(projectId: model.projectId)
                }
            })
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
