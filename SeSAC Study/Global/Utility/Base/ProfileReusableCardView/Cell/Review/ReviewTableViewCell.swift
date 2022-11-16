//
//  ReviewTextView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import SnapKit

final class ReviewTableViewCell: BaseTableViewCell {
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = CardViewSection.review.titleString
        label.font = UIFont(name: CustomFont.regular, size: 12)
        return label
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: CustomFont.regular, size: 14)
        view.text = "sdkfjsadklfjasd;lfjasdlfjdsafjsdaklfjdsklㄴㅁㅇㄹㅇㅁㄴㄹㅁㄴㅇㄹㄴㅁㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㄴㅁㅇㄹㄴㅇㄹㄴㅇㅁㄹㄴㅇㄹㄴㅇㅁㄹㅁㄴㅇㄹㄴㅇㅁㄹㄴㅁㅇㄹㄴㅁㅇㄹㄴㅁ\nasdfdsafasdfsafsadfasfnasdasdfasdfsadfsadfasdfsadfsdansad\n;sdaklfj;\nasdk"
//        view.backgroundColor = .brown
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let detailButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: ImageName.rightChevron)
        configuration.baseForegroundColor = .graySeven
        button.configuration = configuration
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: ReviewTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        [reviewLabel, textView, detailButton].forEach {
            contentView.addSubview($0)
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
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
            //MARK: - 얘도 임시
//            make.height.equalTo(112)
        }
    }
}
