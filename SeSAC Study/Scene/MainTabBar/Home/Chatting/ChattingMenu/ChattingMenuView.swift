//
//  ChattingMenuView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/29.
//

import UIKit
import SnapKit

final class ChattingMenuView: BaseView {

    let menuStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.backgroundColor = .white
        view.distribution = .fillEqually
        return view
    }()
    let reportButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: ImageName.report)
        configuration.title = "새싹 신고"
        configuration.imagePlacement = .top
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .white
        button.configuration = configuration
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: ImageName.cancelStudy)
        configuration.title = "스터디 취소"
        configuration.imagePlacement = .top
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .white
        button.configuration = configuration
        return button
    }()
    let reviewButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: ImageName.review)
        configuration.title = "리뷰 등록"
        configuration.imagePlacement = .top
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .white
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black.withAlphaComponent(0.5)
    }
    override func configure() {
        super.configure()
        [reportButton, cancelButton, reviewButton].forEach {
            menuStackView.addArrangedSubview($0)
        }
        addSubview(menuStackView)
    }
    override func setUpConstraints() {
        super.setUpConstraints()
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(72)
        }
    }
}
