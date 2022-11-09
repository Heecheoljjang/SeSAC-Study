//
//  BirthdayView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import SnapKit

final class BirthdayView: LoginReusableView {
    
    let dateStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 20
        return view
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    lazy var hiddenTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.inputView = datePicker
        textField.textColor = .clear
        textField.tintColor = .clear
        return textField
    }()
    
    let yearView = DateReusableView(dateString: DateString.year.message, placeholder: Date().dateToString(type: .year))
    let monthView = DateReusableView(dateString: DateString.month.message, placeholder: Date().dateToString(type: .month))
    let dayView = DateReusableView(dateString: DateString.day.message, placeholder: Date().dateToString(type: .day))
    
    override init(message: String, detailMessage: String, buttonTitle: String) {
        super.init(message: message, detailMessage: detailMessage, buttonTitle: buttonTitle)
        
        detailMessageLabel.isHidden = true
    }
    
    override func configure() {
        super.configure()
        
        [yearView, monthView, dayView].forEach {
            dateStackView.addArrangedSubview($0)
        }
        [dateStackView, hiddenTextField].forEach {
            addSubview($0)
        }
//        addSubview(dateStackView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        hiddenTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
