//
//  ObjectSelectViewModel.swift
//  IOSAR
//
//  Created by sangmin han on 2021/08/01.
//

import Foundation
import RxSwift
import RxCocoa


class ObjectSelectViewModel: NSObject {
    
    
    var data = BehaviorRelay<[ObjectCellModel]>(value: [])
    
    
    private var _data : [ObjectCellModel] = []
    
    private let thumbnailGenerator =  ARQLThumbnailGenerator()
    
    weak var coordinator : ObjectSelectionCoordinatorProtocol?
    
    func fetchData(){
        
        VirtualObject.availableObjects.forEach { model  in
            if var cache = (UserDefaults.standard.dictionary(forKey: "cacheImage") as? [String:Data]) {
                if let image = cache.filter({ $0.key == model.modelName }).first {
                    _data.append(ObjectCellModel(image: UIImage(data: image.1)!, name: model.modelName,object: model))
                }
                else if let image = thumbnailGenerator.thumbnail(for: model.referenceURL, size: CGSize(width: 100, height: 100)) {
                    _data.append(ObjectCellModel(image: image, name: model.modelName,object: model))
                    cache[model.modelName] = image.jpegData(compressionQuality: 0.5)!
                    UserDefaults.standard.setValue(cache, forKey: "cacheImage")
                }
            }
        }
        data.accept(_data)
        
    }
    
    
    
    func objectSelected(model : ObjectCellModel){
        coordinator?.objectSelected(object: model.object)
    }
    
    
    
    
    
    
}
