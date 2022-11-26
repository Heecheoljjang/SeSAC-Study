//
//  SesacReviewTableViewCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/27.
//

import UIKit
import SnapKit

final class SesacReviewTableViewCell: BaseTableViewCell {
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.regular, size: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: SesacReviewTableViewCell.identifier)
    }
    
    override func configure() {
        contentView.addSubview(reviewLabel)
    }
    
    override func setUpConstraints() {
        reviewLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(16)
        }
    }
}

