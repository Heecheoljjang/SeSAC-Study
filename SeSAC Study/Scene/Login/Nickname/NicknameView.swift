//
//  NicknameView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import SnapKit

final class NicknameView: LoginReusableView {
        
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LoginText.nickName.placeholder
        textField.font = .systemFont(ofSize: 14)
        
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
        
        [nicknameTextField, lineView].forEach {
            addSubview($0)
        }
        self.detailMessageLabel.isHidden = true
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.horizontalEdges.equalToSuperview().inset(28)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
    }
}

