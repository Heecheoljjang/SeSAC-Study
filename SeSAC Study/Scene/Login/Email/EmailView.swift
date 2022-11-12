//
//  EmailView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import SnapKit

final class EmailView: LoginReusableView {
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LoginText.email.placeholder
        textField.font = UIFont(name: CustomFont.regular, size: 14)
        textField.keyboardType = .emailAddress
        
        return textField
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayThree
        return view
    }()
    
    override init(message: String, detailMessage: String, buttonTitle: String) {
        super.init(message: message, detailMessage: detailMessage, buttonTitle: buttonTitle)
    }
    
    override func configure() {
        super.configure()
        
        [emailTextField, lineView].forEach {
            addSubview($0)
        }
        detailMessageLabel.isHidden = true
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
//        stackView.snp.removeConstraints()
//        
//        stackView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(160)
//            make.horizontalEdges.equalToSuperview().inset(73)
//            make.height.equalTo(72)
//        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(288)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
    }
}
