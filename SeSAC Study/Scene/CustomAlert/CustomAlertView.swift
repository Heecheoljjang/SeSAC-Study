//
//  CustomAlertView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/26.
//

import UIKit
import SnapKit

final class CustomAlertView: BaseView {

    let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.spacing = 8
        view.axis = .vertical
        return view
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        label.textAlignment = .center
        label.text = CustomAlert.nearUser.title
        return label
    }()
    let messagelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.textColor = .graySeven
        label.text = CustomAlert.nearUser.message
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = 8
        view.axis = .horizontal
        return view
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = CustomAlert.nearUser.cancelTitle
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .grayTwo
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.configuration = configuration
        return button
    }()
    let okButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = CustomAlert.nearUser.okTitle
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .brandGreen
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    override func configure() {
        super.configure()
        [titleLabel, messagelabel].forEach {
            stackView.addArrangedSubview($0)
        }
        [cancelButton, okButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        [stackView, buttonStackView].forEach {
            alertView.addSubview($0)
        }
        addSubview(alertView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        alertView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-16)
        }
    }
}
