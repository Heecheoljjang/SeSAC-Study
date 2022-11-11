//
//  DateReusableView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import SnapKit

class DateReusableView: BaseView {
    
    var dateString: String = ""
    var placeholder: String = ""
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = dateString
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .black
        textField.placeholder = placeholder
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = false
        
        return textField
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayThree
        
        return view
    }()
    
    init(dateString: String, placeholder: String) {
        self.dateString = dateString
        self.placeholder = placeholder
        super.init(frame: CGRect.zero)
        
    }
    
    override func configure() {
        super.configure()
        
        [dateLabel, dateTextField, lineView].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(16)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.leading.equalToSuperview()
            make.trailing.equalTo(dateLabel.snp.leading)
        }
        
        dateTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(dateLabel.snp.leading)
            make.bottom.equalTo(lineView.snp.top)
            make.top.equalToSuperview()
        }
    }
}
