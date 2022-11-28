//
//  ChattingHeaderView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/26.
//

import UIKit
import SnapKit

final class ChattingHeaderView: BaseView {
    
    let dateLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .graySeven
        view.layer.cornerRadius = 14
        
        return view
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: CustomFont.medium, size: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "1월 15일 토요일"
        return label
    }()
    
    let matchedView: UIView = {
        let view = UIView()
        return view
    }()
    let bellImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: ImageName.bell)
        view.tintColor = .graySeven
        return view
    }()
    let matchedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .graySeven
        label.font = UIFont(name: CustomFont.medium, size: 14)
        label.textAlignment = .center
        label.text = "윤희철님과 매칭되었습니다"
        return label
    }()
    
    let smileLabel: UILabel = {
        let label = UILabel()
        label.textColor = .graySix
        label.font = UIFont(name: CustomFont.regular, size: 14)
        label.text = "채팅을 통해 약속을 정해보세요 :)" //따로 사용되지도 않기때문에 enum으로 뺄 이유가 없음.
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        dateLabelView.addSubview(dateLabel)
        [bellImage, matchedLabel].forEach {
            matchedView.addSubview($0)
        }
        [dateLabelView, matchedView, smileLabel].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        dateLabelView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.height.equalTo(28)
        }
        
        bellImage.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        matchedLabel.snp.makeConstraints { make in
            make.leading.equalTo(bellImage.snp.trailing).offset(6)
            make.verticalEdges.trailing.equalToSuperview()
        }
        matchedView.snp.makeConstraints { make in
            make.top.equalTo(dateLabelView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        smileLabel.snp.makeConstraints { make in
            make.top.equalTo(matchedView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}
