//
//  ProfileView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
////

import UIKit
import SnapKit

final class ProfileView: BaseView {
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let cardView = ProfileReusableCardView()
    
    let settingView: UIView = {
        let view = UIView()
        return view
    }()
    
    let genderView = MyGenderView()
    let studyView = StudyView()
    let searchView = NumberSearchView()
    let ageView = TargetAgeView()
    
    let withdrawButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.title = SettingViewTitle.withdraw
        configuration.baseForegroundColor = .black
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = configuration
        button.contentHorizontalAlignment = .left
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configure() {
        super.configure()
        [genderView, studyView, searchView, ageView, withdrawButton].forEach {
            settingView.addSubview($0)
        }
        [cardView, settingView].forEach {
            contentView.addSubview($0)
        }
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.equalToSuperview()
            make.bottom.equalTo(scrollView).offset(10)
        }
        cardView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(settingView.snp.top).offset(-24) //MARK: 임시
        }
        settingView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        genderView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
        }
        studyView.snp.makeConstraints { make in
            make.top.equalTo(genderView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
        }
        searchView.snp.makeConstraints { make in
            make.top.equalTo(studyView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
        }
        ageView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(84)
        }
        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(ageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
}
