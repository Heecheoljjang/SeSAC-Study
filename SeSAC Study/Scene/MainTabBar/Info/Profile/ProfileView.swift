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
//        view.backgroundColor = .brown
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
//        view.backgroundColor = .brandGreen
        return view
    }()
    
    let cardView = ProfileReusableCardView()
    
    let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let headerView = NameHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configure() {
        super.configure()
        [cardView, testView].forEach {
            contentView.addSubview($0)
        }
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        scrollView.snp.makeConstraints { make in
//            make.horizontalEdges.bottom.equalToSuperview()
//            make.top.equalTo(self.safeAreaLayoutGuide)
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
//            make.width.equalToSuperview()
//            make.centerX.top.equalToSuperview()
//            make.bottom.equalTo(scrollView).offset(10)
            make.edges.equalToSuperview()
        }
        cardView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
//            make.height.greaterThanOrEqualTo(1000)
            make.bottom.equalTo(testView.snp.top).offset(-24) //MARK: 임시
        }
        testView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(336)
        }
    }
}
