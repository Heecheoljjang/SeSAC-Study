//
//  OnboardingCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import UIKit
import SnapKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        [messageLabel, imageView].forEach {
            addSubview($0)
        }
        backgroundColor = .white
    }
    
    private func setUpConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
            make.width.equalTo(232)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(52)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalToSuperview()
        }
    }
}
