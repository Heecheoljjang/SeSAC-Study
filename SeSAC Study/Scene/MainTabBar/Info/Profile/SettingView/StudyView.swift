//
//  StudyView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/21.
//

import UIKit
import SnapKit

final class StudyView: BaseView {
    
    let studyLabel: UILabel = {
        let label = UILabel()
        label.text = SettingViewTitle.study
        label.font = UIFont(name: CustomFont.regular, size: 14)
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: CustomFont.regular, size: 14)
        textField.placeholder = PlaceHolder.myInfoStudy
        return textField
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayThree
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [studyLabel, textField, lineView].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        studyLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(148)
            make.height.equalTo(24)
        }
        lineView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.width.equalTo(164)
        }
    }
}
