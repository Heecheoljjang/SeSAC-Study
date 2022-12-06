//
//  ShopBackgroundTableViewCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/05.
//

import UIKit
import SnapKit

final class ShopBackgroundTableViewCell: BaseTableViewCell {
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.image = UIImage(named: BackgroundImage.fifth.imageName)
        return view
    }()
    
    let infoView: UIView = {
        let view = UIView()
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.text = "윤희철새싹"
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
        label.text = "skfnasdlkfnsadlkfnsadlfnasdlfnsdalfnsdlfsdnlaskdnfals;dk"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: ShopBackgroundTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        [nameLabel, priceButton, infoLabel].forEach {
            infoView.addSubview($0)
        }
        [backgroundImageView, infoView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        backgroundImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(164)
            make.width.equalTo(backgroundImageView.snp.height)
        }
        infoView.snp.makeConstraints { make in
            make.centerY.equalTo(backgroundImageView)
            make.leading.equalTo(backgroundImageView.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.lessThanOrEqualTo(164)
        }
        nameLabel.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(8)
            make.trailing.lessThanOrEqualTo(priceButton.snp.leading).offset(-16)
        }

        priceButton.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        priceButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(20)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}
