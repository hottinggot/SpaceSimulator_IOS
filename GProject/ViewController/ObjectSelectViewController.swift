//
//  ObjectSelectViewController.swift
//  IOSAR
//
//  Created by sangmin han on 2021/08/01.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture


class ObjectSelectViewController: UIView {
    
    
    
    var defaulheight : CGFloat = 300
    
    let maxHeight = UIScreen.main.bounds.height - 100
    let minHeight : CGFloat = 100
    var currentHeight : CGFloat = 300

    
    private var bottomsheet = UIView()
    
    lazy private var bottomsheetBottomanc : NSLayoutConstraint = {
        return bottomsheet.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
    }()
    
    lazy private var bottomsheetHeithanc : NSLayoutConstraint = {
        return bottomsheet.heightAnchor.constraint(equalToConstant: defaulheight)
    }()
    
    
    lazy private var cv : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    
    
    
    var viewModel : ObjectSelectViewModel!
    var disposeBag = DisposeBag()
    
    private var cellid = "objectSelectCellid"
    
    
    init(frame: CGRect,viewmodel : ObjectSelectViewModel) {
        super.init(frame: frame)
        self.alpha = 1
        self.backgroundColor = .clear
        self.viewModel = viewmodel
        makebottomsheet()
        makecv()
        bindView()
        viewModel.fetchData()
        
        bottomsheet.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [unowned self] in
            bottomsheet.layer.cornerRadius = 25
            bottomsheet.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }

    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    
        let hittestView = super.hitTest(point, with: event)
        
        if hittestView == self {
            return nil
        }
        else {
            return hittestView
        }
        
    }
    
    
    
    
    
    func bindView(){
        cv.register(ObjectSelectionCell.self, forCellWithReuseIdentifier: cellid)
        cv.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.data
            .bind(to: cv.rx.items) { [unowned self] (cv, index, model) -> UICollectionViewCell in
                let cell = cv.dequeueReusableCell(withReuseIdentifier: cellid, for: IndexPath(row: index, section: 0)) as! ObjectSelectionCell
                cell.image.image = model.image
                return cell
            }
            .disposed(by: disposeBag)
        
        
        cv.rx.modelSelected(ObjectCellModel.self)
            .bind{ [unowned self] model in
                viewModel.objectSelected(model: model)
            }
            .disposed(by: disposeBag)
        
        
        //gesture
        
        self.bottomsheet.rx.panGesture()
            .when(.ended)
            .subscribe(onNext : { [unowned self] gesture in
                let translation = gesture.translation(in: self)
                let isDown = translation.y > 0

                let height = currentHeight - translation.y

                if height < minHeight {
                    self.animateDismissbottomSheet()
                }
                else if height < defaulheight {
                    self.animateBottomSheetHeight(height: defaulheight)

                }
                else if height < maxHeight && isDown {
                    self.animateBottomSheetHeight(height: defaulheight)
                }
                else if height > defaulheight && isDown == false {
                    self.animateBottomSheetHeight(height: maxHeight)
                }
                


            })
            .disposed(by: disposeBag)

        self.bottomsheet.rx.panGesture()
            .when(.changed)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext : { [unowned self] gesture in
                let translation = gesture.translation(in: self)
                
                let height = currentHeight - translation.y

                if height < maxHeight {
                    print(height)
                    UIView.animate(withDuration: 0.1) { [unowned self] in
                        bottomsheetHeithanc.constant = height
                        self.layoutIfNeeded()
                    }
                    
                }
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    
    
    private func animateBottomSheetHeight(height : CGFloat){
        
        UIView.animate(withDuration: 0.1) { [unowned self] in
            bottomsheetHeithanc.constant = height
            self.layoutIfNeeded()
        }
        currentHeight = height
        
    }
    
    
    
    func animateDismissbottomSheet(){
        animateBottomSheetHeight(height: defaulheight)
        UIView.animate(withDuration: 1) { [unowned self] in
            self.bottomsheetBottomanc.constant = defaulheight - 100
            self.layoutIfNeeded()
        }

    }
    
    
    
    
}

extension ObjectSelectViewController {
    private func makebottomsheet(){
        self.addSubview(bottomsheet)
        bottomsheet.translatesAutoresizingMaskIntoConstraints = false
        bottomsheet.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        bottomsheet.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        bottomsheetBottomanc.isActive = true
        bottomsheetBottomanc.constant = defaulheight - 100
        bottomsheetHeithanc.isActive = true
        
        bottomsheet.backgroundColor = .init(white: 0, alpha: 0.5)
    }
    private func makecv(){
        self.addSubview(cv)
        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        cv.topAnchor.constraint(equalTo: bottomsheet.topAnchor, constant: 50).isActive = true
        cv.leadingAnchor.constraint(equalTo: bottomsheet.leadingAnchor, constant: 25).isActive = true
        cv.trailingAnchor.constraint(equalTo: bottomsheet.trailingAnchor, constant: -25).isActive = true
        cv.bottomAnchor.constraint(equalTo: bottomsheet.bottomAnchor, constant: -25).isActive = true
        cv.backgroundColor = .clear
    }
    
    
    
}
extension ObjectSelectViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
