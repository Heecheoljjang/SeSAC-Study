//
//  BaseCollectionViewCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/15.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpContraints()
    }
        
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {}
    
    func setUpContraints() {}
}
