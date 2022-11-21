//
//  TargetAgeView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/21.
//

import UIKit
import SnapKit
import MultiSlider

final class TargetAgeView: BaseView {
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = SettingViewTitle.targetAge
        label.font = UIFont(name: CustomFont.regular, size: 14)
        return label
    }()
    
    let settingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.textColor = .brandGreen
//        label.text = "18-65" //MARK: 임시
        return label
    }()
    
    let slider: MultiSlider = {
        let slider = MultiSlider()
        slider.thumbTintColor = .brandGreen
        slider.tintColor = .brandGreen
        slider.snapStepSize = 1
        slider.maximumValue = 65
        slider.minimumValue = 18
        slider.orientation = .horizontal
        slider.outerTrackColor = .grayTwo
        slider.hasRoundTrackEnds = true
//        slider.value = [1,65]
        return slider
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [ageLabel, settingLabel, slider].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        ageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        settingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(ageLabel)
        }
        slider.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(ageLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
