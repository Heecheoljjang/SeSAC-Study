//
//  ProfileReusableCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import SnapKit

class ProfileReusableCardView: BaseView {
        
    let imageSetView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        
        return view
    }()
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: ProfileImage.background)
        return view
    }()
    
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ProfileImage.sesacFirst)
        return view
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        
        var title = AttributedString.init(ButtonTitle.requestFriend)
        title.font = UIFont(name: CustomFont.regular, size: 14)
        configuration.attributedTitle = title
        
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .error
        configuration.cornerStyle = .medium
        
        button.configuration = configuration
        return button
    }()
    
    let tableView: DynamicTableView = {
        let view = DynamicTableView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grayTwo.cgColor
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.register(SesacTitleTableViewCell.self, forCellReuseIdentifier: SesacTitleTableViewCell.identifier)
        view.register(StudyTableViewCell.self, forCellReuseIdentifier: StudyTableViewCell.identifier)
        view.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.identifier)
        view.sectionHeaderTopPadding = 0

        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [backgroundImageView, sesacImageView].forEach {
            imageSetView.addSubview($0)
        }
        [imageSetView, requestButton, tableView].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        imageSetView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(192)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.size.equalTo(184)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(19)
        }
        requestButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(backgroundImageView).inset(12)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
