//
//  LaunchView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import UIKit
import SnapKit

final class LaunchView: BaseView {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageName.splash)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = OnboardingData.third.message
        label.font = .systemFont(ofSize: 42, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [imageView, label].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(140)
            make.centerX.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(36)
            make.height.equalTo(88)
            make.centerX.equalToSuperview()
        }
    }
}
