//
//  CollectionViewCell.swift
//  GProject
//
//  Created by 서정 on 2021/08/25.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
