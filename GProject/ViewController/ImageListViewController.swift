//
//  ImageListViewController.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher


class ImageListViewController: UIViewController {
    
    
    
    var topbox = UIView()
    
    var backBtn = UIButton()
    
    
    var imageUploadBtn = UIButton()
    
    
    lazy var imageCv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ImageListCell.self, forCellWithReuseIdentifier: "imagelistCellid")
        return cv
    }()
    
    
    
    private let viewModel = ImageListViewModel()
    
    
    private var disposebag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        maketopbox()
        makebackbtn()
        makeimageUploadbtn()
        makecv()
        
        
        
        
        bindView()
        
    }
    
    
    
    private func bindView(){
        
        
        //collectionview Setup
        
        if let layout = imageCv.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = (UIScreen.main.bounds.width - 30) / 2
            let cellHeight = cellWidth
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            
        }
        
        //output

        viewModel.imageListData
            .bind(to: imageCv.rx.items(cellIdentifier: "imagelistCellid", cellType: ImageListCell.self)) { (row, element, cell) in
                if let url = URL(string: element.url) {
                    cell.image.kf.setImage(with: url)
                }
                else {
                    cell.backgroundColor = .gray
                }
            }
            .disposed(by: disposebag)
        
        
        
        
        //action
        self.backBtn.rx.tap
            .subscribe(onNext : { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposebag)
        
        
        imageCv.rx.modelSelected(ImageListData.self)
            .map{ $0.imageFileId }
            .bind(to: viewModel.currentSelectedImage)
            .disposed(by: disposebag)
        
        imageUploadBtn.rx.tap
            .subscribe(onNext : { [unowned self] in
                let view = UploadImageViewController()
                self.navigationController?.pushViewController(view, animated: true)
            })
            .disposed(by: disposebag)
    
    }
    
    
}
extension ImageListViewController {
    private func maketopbox(){
        self.view.addSubview(topbox)
        topbox.translatesAutoresizingMaskIntoConstraints = false
        topbox.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        topbox.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        topbox.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        topbox.heightAnchor.constraint(equalToConstant: 60).isActive = true
        topbox.backgroundColor = .white
    }
    private func makebackbtn(){
        self.view.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.centerYAnchor.constraint(equalTo: topbox.centerYAnchor, constant: 0).isActive = true
        backBtn.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backBtn.backgroundColor = .red
    }
    
    private func makeimageUploadbtn(){
        self.view.addSubview(imageUploadBtn)
        imageUploadBtn.translatesAutoresizingMaskIntoConstraints = false
        imageUploadBtn.centerYAnchor.constraint(equalTo: topbox.centerYAnchor, constant: 0).isActive = true
        imageUploadBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        imageUploadBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageUploadBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageUploadBtn.setTitle("이미지 업로드 하기", for: .normal)
        imageUploadBtn.setTitleColor(.black, for: .normal)
        imageUploadBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        imageUploadBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    
    private func makecv(){
        self.view.addSubview(imageCv)
        imageCv.translatesAutoresizingMaskIntoConstraints = false
        imageCv.topAnchor.constraint(equalTo: topbox.bottomAnchor, constant: 15).isActive = true
        imageCv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        imageCv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        imageCv.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        imageCv.backgroundColor = .clear
    }
    
    
    
    
    
}
