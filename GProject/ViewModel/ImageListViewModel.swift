//
//  ImageListViewModel.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import RxSwift
import RxCocoa



class ImageListViewModel {
    
    //data
    let coordinate = ViewCoordinator()
    
    //output
     var imageListData = BehaviorRelay<[ImageListData]>(value: [])
    
    
    //input
    var currentSelectedImage = PublishSubject<Int>()
    
    
    private let service: DataServiceType!
    private var disposebag = DisposeBag()
    
    init(service : DataServiceType = DataService()){
        self.service = service
        
        fetchdata()
        
        currentSelectedImage
            .subscribe(onNext : { [unowned self] imageFileId in
                coordinate.start()
            })
            .disposed(by: disposebag)
    }
    
    

    private func fetchdata(){
        FunctionClass.shared.showdialog(show: true)
        service.getImageList()
            .subscribe(onNext : { [unowned self] data in
                print(data)
                imageListData.accept(data)
                FunctionClass.shared.showdialog(show: false)
            })
            .disposed(by: disposebag)
    }
    
    
    
}


