//
//  GenderView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/10.
//

import UIKit
import SnapKit

final class GenderView: LoginReusableView {
    
    let genderStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 12
        return view
    }()
    
    let manView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grayThree.cgColor
        
        return view
    }()
    
    let manImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageName.man)
        return view
    }()
    
    let manLabel: UILabel = {
        let label = UILabel()
        label.text = Gender.man.text
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    let womanView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grayThree.cgColor
        
        return view
    }()
    
    let womanImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageName.woman)
        return view
    }()
    
    let womanLabel: UILabel = {
        let label = UILabel()
        label.text = Gender.woman.text
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    override init(message: String, detailMessage: String, buttonTitle: String) {
        super.init(message: message, detailMessage: detailMessage, buttonTitle: buttonTitle)
    }
    
    override func configure() {
        super.configure()
        
        [manImage, manLabel].forEach {
            manView.addSubview($0)
        }
        [womanImage, womanLabel].forEach {
            womanView.addSubview($0)
        }
        [manView, womanView].forEach {
            genderStackView.addArrangedSubview($0)
        }
        addSubview(genderStackView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        manImage.snp.makeConstraints { make in
            make.size.equalTo(72)
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        manLabel.snp.makeConstraints { make in
            make.top.equalTo(manImage.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(28)
        }
        
        womanImage.snp.makeConstraints { make in
            make.size.equalTo(72)
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        womanLabel.snp.makeConstraints { make in
            make.top.equalTo(womanImage.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(28)
        }
        
        genderStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(doneButton)
            make.top.equalTo(stackView.snp.bottom).offset(28)
            make.bottom.equalTo(doneButton.snp.top).offset(-32)
        }
    }
}
