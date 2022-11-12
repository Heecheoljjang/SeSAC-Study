//
//  PhoneAuthView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit
import SnapKit

final class PhoneAuthView: LoginReusableView {
    
    let authTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.regular, size: 14)
        textField.placeholder = LoginText.phoneAuth.placeholder
        textField.textAlignment = .left
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayThree
        
        return view
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brandGreen
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.text = "05:00" //임시
        
        return label
    }()
    
    let retryButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = ButtonTitle.retryButtonTitle
        configuration.baseBackgroundColor = .brandGreen
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        
        button.configuration = configuration
        return button
    }()

    override init(message: String, detailMessage: String, buttonTitle: String) {
        super.init(message: message, detailMessage: detailMessage, buttonTitle: buttonTitle)
    }
    
    override func configure() {
        super.configure()
        
        [authTextField, lineView, timerLabel, retryButton].forEach {
            addSubview($0)
        }
        detailMessageLabel.isHidden = true
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        retryButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(276)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.width.equalTo(72)
        }

        timerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(retryButton.snp.leading).offset(-20)
            make.centerY.equalTo(retryButton)
            make.width.equalTo(40)
        }

        authTextField.snp.makeConstraints { make in
            make.trailing.equalTo(timerLabel.snp.leading).offset(-20)
            make.leading.equalToSuperview().offset(28)
            make.centerY.equalTo(retryButton)
        }

        lineView.snp.makeConstraints { make in
            make.top.equalTo(authTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(retryButton.snp.leading).offset(-8)
            make.height.equalTo(1)
        }
    }
}
