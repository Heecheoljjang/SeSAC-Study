//
//  InfoView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import SnapKit

final class InfoView: BaseView {
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 0
        view.backgroundColor = .error
        return view
    }()
    
    let noticeView = MyInfoReusableView(type: .notice)
    let faqView = MyInfoReusableView(type: .faq)
    let qnaView = MyInfoReusableView(type: .qna)
    let alarmView = MyInfoReusableView(type: .alarm)
    let permitView = MyInfoReusableView(type: .permit)
    
    let clearButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .clear
        configuration.baseBackgroundColor = .clear
        button.configuration = configuration
        return button
    }()
    
    let profileView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageName.sesacFace)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grayTwo.cgColor
        view.layer.cornerRadius = 24
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 16)
        label.text = "김새싹"
        return label
    }()
    
    let detailImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageName.rightChevron)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [profileImage, nameLabel, detailImageView].forEach {
            profileView.addSubview($0)
        }
        [noticeView, faqView, qnaView, alarmView, permitView].forEach {
            stackView.addArrangedSubview($0)
        }
        [stackView, profileView, clearButton].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        clearButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(380)
        }
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImage.snp.trailing).offset(12)
            make.centerY.equalTo(profileImage)
        }
        
        detailImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(profileImage)
            make.height.equalTo(18)
            make.width.equalTo(8)
        }
    }
}
