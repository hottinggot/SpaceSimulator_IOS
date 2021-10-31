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
                
                let waitmodal = ProjectNameInputPopup(frame: del.window!.frame)
                waitmodal.textinput.text = "3D 모델링중..."
                waitmodal.confirmBtn.setTitle("확인하기", for: .normal)
                waitmodal.closeBtn.rx.tap
                    .subscribe(onNext : { [unowned self] in
                        waitmodal.removeFromSuperview()
                    })
                    .disposed(by: disposebag)
                
                waitmodal.confirmBtn.rx.tap
                    .subscribe(onNext : { [unowned self] in
                    // 서버에 OCR 결과 요청
                        self.service.check3dModel(imageFileId: currenSelectedImageId)
                            .bind { checkProjectData in
                                if checkProjectData.isModelExist {
                                    waitmodal.removeFromSuperview()
                                }
                                else {
                                    ToastView.shared.short(txt_msg: "잠시만 기다려주세요.")
                                    FunctionClass.shared.showdialog(show: false)
                                }
                                
                            }
                            .disposed(by: disposebag)
                    })
                    .disposed(by: disposebag)
                
                
                
                let popup = ProjectNameInputPopup(frame: del.window!.frame)
                popup.textinput.becomeFirstResponder()
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
//                        del.window?.addSubview(waitmodal)
                        
                        service.postProjectInfo(data: ProjectRequestData(projectId: currenSelectedImageId, projectName: projectName))
                            .subscribe(onNext : { [unowned self] data in
                                print("DATA: ", data)
                                if !data.isModelExist {
                                    del.window?.addSubview(waitmodal)
                                }
                                
                                //else: 모델 존재한다면 AR로 이동
                                
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


