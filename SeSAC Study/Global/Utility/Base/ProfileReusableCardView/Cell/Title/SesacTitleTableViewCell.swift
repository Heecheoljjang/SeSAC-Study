//
//  StackViewCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import SnapKit

final class SesacTitleTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = CardViewSection.title.titleString
        label.font = UIFont(name: CustomFont.regular, size: 12)
        return label
    }()
    
    let outerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let leftStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    let rightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 8
        return view
    }()
    
    let goodButton = ReusableButton(title: SeSacTitle.good.buttonTitle)
    let timeButton = ReusableButton(title: SeSacTitle.time.buttonTitle)
    let fastButton = ReusableButton(title: SeSacTitle.fast.buttonTitle)
    let kindButton = ReusableButton(title: SeSacTitle.kind.buttonTitle)
    let expertButton = ReusableButton(title: SeSacTitle.expert.buttonTitle)
    let helpfulButton = ReusableButton(title: SeSacTitle.helpful.buttonTitle)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: SesacTitleTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        [goodButton, fastButton, expertButton].forEach {
            leftStackView.addArrangedSubview($0)
        }
        [timeButton, kindButton, helpfulButton].forEach {
            rightStackView.addArrangedSubview($0)
        }
        [leftStackView, rightStackView].forEach {
            outerView.addSubview($0)
        }
        [titleLabel, outerView].forEach {
            contentView.addSubview($0)
        }
    }
    
    //MARK: - 높이: 194 고정
    override func setUpConstraints() {
        super.setUpConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        outerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(112)
        }
        
        leftStackView.snp.makeConstraints { make in
//            make.leading.equalTo(titleLabel)
//            make.width.equalTo(rightStackView)
//            make.trailing.equalTo(rightStackView.snp.leading).offset(-8)
            make.verticalEdges.leading.equalToSuperview()
            make.width.equalTo(rightStackView)
            make.trailing.equalTo(rightStackView.snp.leading).offset(-8)
        }
        
        rightStackView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
        }
    }
}


