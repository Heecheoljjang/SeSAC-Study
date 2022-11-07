//
//  PhoneNumberView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit
import SnapKit

final class PhoneNumberView: BaseView {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = Message.phoneNumber
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    let numberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = PlaceHolder.phoneNumber
        textField.font = .systemFont(ofSize: 14)
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayThree
        
        return view
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = ButtonTitle.authButtonTitle
        configuration.baseForegroundColor = .grayThree
        configuration.baseBackgroundColor = .graySix
        configuration.cornerStyle = .medium
        
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    override func configure() {
        super.configure()
        
        [messageLabel, numberTextField, lineView, doneButton].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.horizontalEdges.equalToSuperview().inset(73.5)
        }
        
        numberTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(400) //위치 똑같이 만들어주기 위해
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
