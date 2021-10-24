//
//  ViewCoordinator.swift
//  GProject
//
//  Created by sangmin han on 2021/10/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


protocol ObjectSelectionCoordinatorProtocol : AnyObject {
    func objectSelected(object : VirtualObject)
    
}

class ViewCoordinator  {
    
    var disposebag = DisposeBag()
    
    var rootView = ARViewController()
    var bottomsheet :  ObjectSelectViewController!
    
    func start(){
        let viewmodel = ARViewModel()
        viewmodel.coordinator = self
        rootView.viewmodel = ARViewModel()
        viewmodel.getCoordinates()
            .subscribe(onNext : { [unowned self] in
                guard let scene = UIApplication.shared.connectedScenes.first else { return }
                guard let del = scene.delegate as? SceneDelegate else { return }
                (del.window?.rootViewController as? UINavigationController)?.pushViewController(rootView, animated: true)
            })
            .disposed(by: disposebag)
        

      
        
        self.showObjectselectionViewController()
    }
    
    
    
    private func showObjectselectionViewController(){
        bottomsheet = ObjectSelectViewController(frame: .zero, viewmodel: ObjectSelectViewModel())
        bottomsheet.viewModel.coordinator = self
        rootView.view.addSubview(bottomsheet)
        bottomsheet.frame = rootView.view.frame
        
    }
    
}

extension ViewCoordinator : ObjectSelectionCoordinatorProtocol {
    func objectSelected(object: VirtualObject) {
        bottomsheet.animateDismissbottomSheet()
        rootView.loadObject(object: object)
    }
    
    
}
