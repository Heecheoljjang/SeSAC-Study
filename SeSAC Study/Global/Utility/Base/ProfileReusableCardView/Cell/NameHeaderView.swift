//
//  NameLabelCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/15.
//

import UIKit
import SnapKit

final class NameHeaderView: BaseView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        
        return label
    }()

    let chevronButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = .graySeven
        configuration.image = UIImage(named: ImageName.upChevron)
        
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [nameLabel, chevronButton].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        chevronButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(chevronButton.snp.leading)
            make.height.equalTo(24)
        }
    }
}
