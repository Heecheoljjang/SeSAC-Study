//
//  ShopSesacCollectionViewCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/05.
//

import UIKit
import SnapKit

final class ShopSesacCollectionViewCell: BaseCollectionViewCell {
    
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.grayTwo.cgColor
        view.layer.borderWidth = 1
        view.image = UIImage(named: ProfileImage.sesacFirst)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular, size: 16)
        label.text = "윤희철새싹윤희철새싹윤희철새싹"
        return label
    }()
    
    let purchaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayTwo
        view.layer.cornerRadius = 10
        return view
    }()
    let purchaseLabel: UILabel = {
        let label = UILabel()
        label.text = "보유" //임시
        label.font = UIFont(name: CustomFont.regular, size: 12)
        label.textColor = .graySeven
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.text = "skfnasdlkfnsadlkfnsadlfnasdlfnsdalfnsdlfsdnlaskdnfals;dk"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func configure() {
        super.configure()
        
        purchaseView.addSubview(purchaseLabel)
        [sesacImageView, nameLabel, purchaseView, infoLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        sesacImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(sesacImageView.snp.width)
        }
        nameLabel.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(sesacImageView.snp.bottom).offset(8)
            make.trailing.equalTo(purchaseView.snp.leading).offset(-8)
        }
        purchaseView.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        purchaseView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        purchaseLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(2)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
