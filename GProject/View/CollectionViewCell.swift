//
//  CollectionViewCell.swift
//  GProject
//
//  Created by 서정 on 2021/08/25.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var titleLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        imageView.clipsToBounds = true
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 3).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor,constant: 3).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -3).isActive = true
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [unowned self] in
            imageView.layer.cornerRadius = 12.5
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
