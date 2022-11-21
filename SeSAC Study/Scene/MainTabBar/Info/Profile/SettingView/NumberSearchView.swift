//
//  NumberSearchView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/21.
//

import UIKit
import SnapKit

final class NumberSearchView: BaseView {
    
    let searchLabel: UILabel = {
        let label = UILabel()
        label.text = SettingViewTitle.search
        label.font = UIFont(name: CustomFont.regular, size: 14)
        return label
    }()
    
    let allowSwitch: UISwitch = {
        let view = UISwitch()
        view.onTintColor = .brandGreen
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [searchLabel, allowSwitch].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        searchLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        allowSwitch.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }
}

