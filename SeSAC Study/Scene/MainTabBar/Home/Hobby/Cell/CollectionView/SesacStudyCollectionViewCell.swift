//
//  SesacStudyCollectionViewCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/19.
//

import UIKit
import SnapKit

final class SesacStudyCollectionViewCell: BaseCollectionViewCell {
    
    let outerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.grayFour.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [outerView, titleLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        outerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.5)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
