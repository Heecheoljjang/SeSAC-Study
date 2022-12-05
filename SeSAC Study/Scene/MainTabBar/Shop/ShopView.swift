//
//  ShopView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

final class ShopView: BaseView {
//    
//    let scrollView: UIScrollView = {
//        let view = UIScrollView()
////        view.backgroundColor = .red
//        return view
//    }()
//    let contentView: UIView = {
//        let view = UIView()
////        view.backgroundColor = .blue
//        return view
//    }()
        
    //MARK: 배경이미지
    let imageSetView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: ProfileImage.background) //임시
        return view
    }()
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ProfileImage.sesacFirst) //임시
        return view
    }()
    let saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .brandGreen
        configuration.cornerStyle = .medium
        configuration.title = ButtonTitle.saveShop
        button.configuration = configuration
        return button
    }()
    

    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func configure() {
        super.configure()
        [backgroundImageView, sesacImageView, saveButton].forEach {
            imageSetView.addSubview($0)
        }
        [imageSetView, containerView].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        imageSetView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(self.safeAreaLayoutGuide).inset(14)
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
        saveButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(imageSetView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
//        contentView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.centerX.equalToSuperview()
//        }
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(self.safeAreaLayoutGuide)
//        }
    }
}
