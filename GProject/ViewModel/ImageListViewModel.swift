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
    private var projectName = ""
    private var currenSelectedImageId : Int = 0
    
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
                self.currenSelectedImageId = imageFileId
                guard let scene = UIApplication.shared.connectedScenes.first else { return }
                guard let del = scene.delegate as? SceneDelegate else { return }
                let popup = ProjectNameInputPopup(frame: del.window!.frame)
                popup.textinput.rx.text.orEmpty
                    .subscribe(onNext : { [unowned self] name in
                        self.projectName = name
                    })
                    .disposed(by: disposebag)
                
                popup.closeBtn.rx.tap
                    .subscribe(onNext : { [unowned self] in
                        popup.removeFromSuperview()
                    })
                    .disposed(by: disposebag)
                
                
                popup.confirmBtn.rx.tap
                    .subscribe(onNext : { [unowned self] in
                        popup.removeFromSuperview()
                        service.postProjectInfo(data: ProjectRequestData(projectId: currenSelectedImageId, projectName: projectName))
                            .subscribe(onNext : { [unowned self] data  in
                                self.coordinate.goback()
                            })
                            .disposed(by: disposebag)
                    })
                    .disposed(by: disposebag)
                
                del.window?.addSubview(popup)
                
                
                
//                coordinate.start()
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


