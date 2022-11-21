//
//  StudyCollectionViewCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import SnapKit

final class StudyCollectionViewCell: BaseCollectionViewCell {
    
    let outerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.graySix.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular, size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        outerView.addSubview(label)
        contentView.addSubview(outerView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        outerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(8)
        }
    }
}
