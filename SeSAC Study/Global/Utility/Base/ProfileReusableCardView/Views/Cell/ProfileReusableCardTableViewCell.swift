////
////  CardTableViewCell.swift
////  SeSAC Study
////
////  Created by HeecheolYoon on 2022/11/15.
////
import UIKit
import SnapKit

final class ProfileTableViewCell: BaseTableViewCell {
    
    //MARK: 배경이미지
    let imageSetView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.image = UIImage(named: ProfileImage.background)
        return view
    }()
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ProfileImage.sesacFirst)
        return view
    }()
    let requestButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        
        var title = AttributedString.init(ButtonTitle.requestFriend)
        title.font = UIFont(name: CustomFont.regular, size: 14)
        configuration.attributedTitle = title
        
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .error
        configuration.cornerStyle = .medium
        
        button.configuration = configuration
        return button
    }()
    
    //MARK: 스택뷰 => 이름, 새싹 타이틀, 하고싶은스터디, 새싹 리뷰
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 0
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grayTwo.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .brandGreen
        return view
    }()
    
    //이름
    let nameView = NameHeaderView()
    //새싹 타이틀
    let sesacTitleView = SesacTitleView()
    //하고싶은스터디
    let studyView = StudyTableView()
    //새싹 리뷰
    let reviewView = ReviewView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: ProfileTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        
        [backgroundImageView, sesacImageView].forEach {
            imageSetView.addSubview($0)
        }
        [nameView, sesacTitleView, studyView, reviewView].forEach {
            stackView.addArrangedSubview($0)
        }
        [imageSetView, requestButton, stackView].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        imageSetView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(192)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        sesacImageView.snp.makeConstraints { make in
            make.size.equalTo(184)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(19)
        }
        requestButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(backgroundImageView).inset(12)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        nameView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        sesacTitleView.snp.makeConstraints { make in
            make.height.equalTo(194)
        }
        studyView.snp.makeConstraints { make in
            make.height.equalTo(68)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageSetView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
