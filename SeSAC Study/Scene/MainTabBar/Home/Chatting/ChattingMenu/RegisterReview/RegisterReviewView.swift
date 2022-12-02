//
//  RegisterReviewView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/02.
//

import UIKit
import SnapKit

final class RegisterReviewView: BaseView {
    
    let outerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰 등록"
        label.font = UIFont(name: CustomFont.medium, size: 14)
        label.textAlignment = .center
        return label
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: ImageName.xmark)
        configuration.baseForegroundColor = .graySix
        button.configuration = configuration
        return button
    }()
    
    let askingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.textAlignment = .center
        label.textColor = .brandGreen
        return label
    }()
    
    let buttonView: UIView = {
        let view = UIView()
        return view
    }()
    let leftStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    let rightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    let goodButton = ReusableButton(title: SeSacTitle.good.buttonTitle)
    let timeButton = ReusableButton(title: SeSacTitle.time.buttonTitle)
    let fastButton = ReusableButton(title: SeSacTitle.fast.buttonTitle)
    let kindButton = ReusableButton(title: SeSacTitle.kind.buttonTitle)
    let expertButton = ReusableButton(title: SeSacTitle.expert.buttonTitle)
    let helpfulButton = ReusableButton(title: SeSacTitle.helpful.buttonTitle)
    
    let textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .grayOne
        view.font = UIFont(name: CustomFont.regular, size: 14)
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .grayThree
        configuration.baseBackgroundColor = .graySix
        configuration.title = ButtonTitle.registerReview
        button.configuration = configuration
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black.withAlphaComponent(0.5)
        goodButton.isUserInteractionEnabled = true
        timeButton.isUserInteractionEnabled = true
        fastButton.isUserInteractionEnabled = true
        kindButton.isUserInteractionEnabled = true
        expertButton.isUserInteractionEnabled = true
        helpfulButton.isUserInteractionEnabled = true
    }
    override func configure() {
        super.configure()
        
        [goodButton, fastButton, expertButton].forEach {
            leftStackView.addArrangedSubview($0)
        }
        [timeButton, kindButton, helpfulButton].forEach {
            rightStackView.addArrangedSubview($0)
        }
        [leftStackView, rightStackView].forEach {
            buttonView.addSubview($0)
        }
        [titleLabel, cancelButton, askingLabel, buttonView, textView, registerButton].forEach {
            outerView.addSubview($0)
        }
        addSubview(outerView)
    }
    override func setUpConstraints() {
        super.setUpConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(14)
        }
        
        askingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        leftStackView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.width.equalTo(rightStackView)
            make.trailing.equalTo(rightStackView.snp.leading).offset(-8)
        }
        rightStackView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
        }
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(askingLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(124)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(124)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        outerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
