//
//  ReviewTextView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import SnapKit

final class ReviewView: BaseView {
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = CardViewSection.review.titleString
        label.font = UIFont(name: CustomFont.regular, size: 12)
        return label
    }()
    
    let label: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: CustomFont.regular, size: 14)
        view.text = PlaceHolder.review
        view.textColor = .graySix
        view.numberOfLines = 0
        return view
    }()
    
    let detailButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: ImageName.rightChevron)
        configuration.baseForegroundColor = .graySeven
        button.configuration = configuration
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [reviewLabel, label, detailButton].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        detailButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(16)
            make.centerY.equalTo(reviewLabel)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
