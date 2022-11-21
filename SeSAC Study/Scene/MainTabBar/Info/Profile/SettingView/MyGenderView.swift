//
//  MyGenderView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/21.
//

import UIKit
import SnapKit

final class MyGenderView: BaseView {
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = SettingViewTitle.gender
        label.font = UIFont(name: CustomFont.regular, size: 14)
        return label
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    let manButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .clear
        configuration.title = "남자"
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.grayFour.cgColor
        button.layer.cornerRadius = 8
        button.configuration = configuration
        return button
    }()
    
    let womanButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .black
        configuration.title = "여자"
        configuration.baseBackgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.grayFour.cgColor
        button.layer.cornerRadius = 8
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [manButton, womanButton].forEach {
            stackView.addArrangedSubview($0)
        }
        [stackView, genderLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        genderLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(48)
        }
    }
}
