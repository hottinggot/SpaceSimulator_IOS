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
    
    let selectAreaButton = UIButton()
    var collectionView: UICollectionView!
    let dropDown = DropDown()

    
    //let viewModel = BoardListViewModel()
    
    let disposeBag = DisposeBag()
    
//    override func viewWillAppear(_ animated: Bool) {
//        viewModel.refreshBoardList()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setView()
        bindSelectAreaButton()
        bindCollectionView()
       
    }
    
    private func setView() {
        self.addSelectAreaButton()
        self.addDropDown()
        self.addCollectionView()
    }
    
    private func addSelectAreaButton() {
        //set property
        selectAreaButton.setTitle("지역 선택", for: .normal)
        selectAreaButton.setTitleColor(.black, for: .normal)
        
        view.addSubview(selectAreaButton)
        
        //set layout
        selectAreaButton.translatesAutoresizingMaskIntoConstraints = false
        selectAreaButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        selectAreaButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private let service  = DataService()
    
    private func addDropDown() {
        //service.getAllCities()
        dropDown.dataSource = ["1", "2", "3"]
        dropDown.anchorView = selectAreaButton
        
        //버튼 아래로 오게하는 코드
//        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        view.addSubview(dropDown)

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
        collectionView.topAnchor.constraint(equalTo: selectAreaButton.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func bindSelectAreaButton() {
        selectAreaButton.rx.tap
            .bind {
                self.dropDown.show()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        let examples = ["A", "B", "C"]
        let data = Observable.of(examples)
        
        data.bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: CollectionViewCell.self)) { (row, element, cell) in
            cell.backgroundColor = .lightGray
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind { idx in
                print(idx[1])
                
                if(idx[1]==0) {
                    self.moveToComposePage()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func moveToComposePage() {
        let composePage: ComposeViewController = ComposeViewController()
//        composePage.viewModel.mode = .CREATE
//        composePage.viewModel.board = Board(title: "", content: "", createdAt: Date().toString(), communityId: 0, nickname: user!.nickname)
        composePage.modalPresentationStyle = .fullScreen
        self.present(composePage, animated: true, completion: nil)
    }

//    private func moveToDetailPage() {
//        let detailVC = DetailViewController()
//        detailVC.viewModel.board = item
//        detailVC.viewModel.user = self.user
//        page.navigationController!.pushViewController(detailVC, animated: true)
//    }
}
