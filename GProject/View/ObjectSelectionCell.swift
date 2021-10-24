//
//  ObjectSelectionCell.swift
//  IOSAR
//
//  Created by sangmin han on 2021/08/01.
//

import Foundation
import UIKit


class ObjectSelectionCell : UICollectionViewCell  {
    
    
    var image = UIImageView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeimage()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [unowned self] in
            image.layer.cornerRadius = 12.5
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension ObjectSelectionCell {
    private func makeimage(){
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        image.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        image.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        image.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        image.clipsToBounds = true
    }
}
