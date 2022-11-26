//
//  NoSesacView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/25.
//

import UIKit
import SnapKit

final class NoSesacView: BaseView {
    
    var bigLabelText: String
    var smallLabelText: String
    
    let sesacImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageName.emptySesac)
        return view
    }()
    
    lazy var bigLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular, size: 20)
        label.textAlignment = .center
        label.text = bigLabelText
        return label
    }()
    
    lazy var smallLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.textAlignment = .center
        label.text = smallLabelText
        label.textColor = .graySeven
        return label
    }()
    
    init(bigLabelText: String, smallLabelText: String) {
        self.bigLabelText = bigLabelText
        self.smallLabelText = smallLabelText
        super.init(frame: CGRect.zero)
    }
    
    override func configure() {
        super.configure()
        [sesacImage, bigLabel, smallLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        sesacImage.snp.makeConstraints { make in
            make.size.equalTo(64)
            make.top.centerX.equalToSuperview()
        }
        bigLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacImage.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
        }
        smallLabel.snp.makeConstraints { make in
            make.top.equalTo(bigLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
