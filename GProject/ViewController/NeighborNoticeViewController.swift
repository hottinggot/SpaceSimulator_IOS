//
//  NeighborNoticeViewController.swift
//  GProject
//
//  Created by 서정 on 2022/04/29.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class NeighborNoticeViewController: UIViewController {

    var disposeBag = DisposeBag()
    let viewModel = NeighborListViewModel()
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, NeighborDetail>>(configureCell: { _, collectionView, indexPath, element in

        let cell = collectionView.dequeueReusableCell(withIdentifier: NeighborTableViewCell.identifier, for: indexPath) as! NeighborTableViewCell

        cell.firstButton.setTitle("승인", for: .normal)
        cell.secondButton.setTitle("삭제", for: .normal)
        cell.nicknameLabel.text = element.nickname ?? "NaN"
        
        cell.firstButtonTappedHandler = { [weak self] in
            var neighborDetail: NeighborDetail = element
            neighborDetail.isApprove = true
            self?.viewModel.bindApplyNeighborButton(neighborDetail: neighborDetail)
            self?.appliedNeighborListTableView.reloadData()
            
        }
        
        cell.secondButtonTappedHandler = { [weak self] in
            var neighborDetail: NeighborDetail = element
            neighborDetail.isApprove = false
            self?.viewModel.bindApplyNeighborButton(neighborDetail: neighborDetail)
            
            self?.appliedNeighborListTableView.reloadData()
        }
        
        return cell
    })
    
    let titleLabel = UILabel()
        .then {
            $0.text = "이웃 요청 목록"
            $0.font = UIFont.systemFont(ofSize: 30.0, weight: .bold)
            $0.textColor = .black
        }
    
    let appliedNeighborListTableView = UITableView()
        .then {
            $0.register(NeighborTableViewCell.self, forCellReuseIdentifier: NeighborTableViewCell.identifier)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutView()
        bindView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.bindAppliedNeighborList()
    }
    
    func configureView() {
        view.backgroundColor = UIColor.appColor(.backgroundBlack)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func layoutView() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.0)
            $0.left.equalToSuperview().offset(20.0)
        }
        
        view.addSubview(appliedNeighborListTableView)
        appliedNeighborListTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5.0)
            $0.left.equalToSuperview().offset(20.0)
            $0.right.equalToSuperview().offset(-20.0)
        }
    }
    
    func bindView() {
        viewModel.appliedNeighborList
            .asDriver()
            .drive(appliedNeighborListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
