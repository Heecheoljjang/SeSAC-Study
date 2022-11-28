//
//  MyChattingCollectionViewCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/28.
//

import UIKit
import SnapKit

final class MyChattingTableViewCell: BaseTableViewCell {
    
    let outerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .brandGreen
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular, size: 12)
        label.textColor = .graySix
        label.text = "15:02"
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MyChattingTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        outerView.addSubview(messageLabel)
        [dateLabel, outerView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        outerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
        messageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(outerView)
            make.trailing.equalTo(outerView.snp.leading).offset(-8)
            make.width.equalTo(32)
            make.leading.greaterThanOrEqualToSuperview().offset(52)
        }
    }
}
