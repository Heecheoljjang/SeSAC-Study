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

    let priceButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.title = "보유"
        configuration.baseBackgroundColor = .grayTwo
        configuration.baseForegroundColor = .graySeven
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { title in
            var new = title
            new.font = UIFont(name: CustomFont.regular, size: 12)
            return new
        }
        button.configuration = configuration
        return button
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func configure() {
        super.configure()

        [sesacImageView, nameLabel, priceButton, infoLabel].forEach {
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
            make.trailing.lessThanOrEqualTo(priceButton.snp.leading).offset(-8)
        }

        priceButton.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        priceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
