////
////  CardTableViewCell.swift
////  SeSAC Study
////
////  Created by HeecheolYoon on 2022/11/15.
////
//
//import UIKit
//import SnapKit
//
//final class ProfileReusableCardTableViewCell: BaseTableViewCell {
//    
//    //MARK: 새싹 타이틀
//    let sesacTitleView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .focus
//        return UIView()
//    }()
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = CardViewSection.title.titleString
//        label.font = UIFont(name: CustomFont.regular, size: 12)
//        label.textAlignment = .left
//        
//        return label
//    }()
//    
////    let outerStackView: UIStackView = {
////        let view = UIStackView()
////        view.axis = .horizontal
////        view.spacing = 8
////        view.distribution = .equalSpacing
////        view.backgroundColor = .brandYellowGreen
////        return view
////    }()
//    let outerView: UIView = {
//        let view = UIView()
//        return view
//    }()
//    
//    let leftStackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.distribution = .equalSpacing
//        view.spacing = 8
//        view.backgroundColor = .error
//        return view
//    }()
//    
//    let rightStackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.distribution = .equalSpacing
//        view.spacing = 8
//        view.backgroundColor = .success
//        return view
//    }()
//    
//    let goodButton = ReusableButton(title: SeSacTitle.good.buttonTitle)
//    let timeButton = ReusableButton(title: SeSacTitle.time.buttonTitle)
//    let fastButton = ReusableButton(title: SeSacTitle.fast.buttonTitle)
//    let kindButton = ReusableButton(title: SeSacTitle.kind.buttonTitle)
//    let expertButton = ReusableButton(title: SeSacTitle.expert.buttonTitle)
//    let helpfulButton = ReusableButton(title: SeSacTitle.helpful.buttonTitle)
//    
//    //MARK: 하고 싶은 스터디
//    let studyView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemTeal
//        return view
//    }()
//    
//    let studyLabel: UILabel = {
//        let label = UILabel()
//        label.text = CardViewSection.study.titleString
//        label.font = UIFont(name: CustomFont.regular, size: 12)
//        
//        return label
//    }()
//    
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 8
//        layout.minimumInteritemSpacing = 8
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        
//        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
//        view.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: StudyCollectionViewCell.identifier)
//        view.isScrollEnabled = false
//        
//        return view
//    }()
//    
//    //MARK: 새싹 리뷰
//    let reviewView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .darkGray
//        return view
//    }()
//    
//    let reviewLabel: UILabel = {
//        let label = UILabel()
//        label.text = CardViewSection.review.titleString
//        label.font = UIFont(name: CustomFont.regular, size: 12)
//        
//        return label
//    }()
//    
//    let textView: UITextView = {
//        let view = UITextView()
//        view.font = UIFont(name: CustomFont.regular, size: 14)
//        view.isScrollEnabled = false
//        return view
//    }()
//    
//    let moreReviewButton: UIButton = {
//        let button = UIButton()
//        var configuration = UIButton.Configuration.plain()
//        configuration.image = UIImage(named: ImageName.rightChevron)
//        
//        button.configuration = configuration
//        return button
//    }()
//    
//    //다 담을 스택뷰
//    let finalStackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.spacing = 24
//        view.distribution = .equalSpacing
//        view.backgroundColor = .purple
//        return view
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: ProfileReusableCardTableViewCell.identifier)
//    }
//    
//    override func configure() {
//        super.configure()
//        [goodButton, fastButton, expertButton].forEach {
//            leftStackView.addArrangedSubview($0)
//        }
//        [timeButton, kindButton, helpfulButton].forEach {
//            rightStackView.addArrangedSubview($0)
//        }
//        [leftStackView, rightStackView].forEach {
////            outerStackView.addArrangedSubview($0)
//            outerView.addSubview($0)
//        }
//        
//        //MARK: 스택뷰로 묶어야 히든하면 알아서 잡힐듯
//        
//        //새싹 타이틀
//        [titleLabel, outerView].forEach { //스택뷰 대신 그냥 뷰
//            sesacTitleView.addSubview($0)
//        }
//        //스터디
//        [studyLabel, collectionView].forEach {
//            studyView.addSubview($0)
//        }
//        //리뷰
//        [reviewLabel, textView, moreReviewButton].forEach {
//            reviewView.addSubview($0)
//        }
//        
//        [sesacTitleView, studyView, reviewView].forEach {
//            finalStackView.addSubview($0)
//        }
//        
//        contentView.addSubview(finalStackView)
//    }
//    
//    override func setUpConstraints() {
//        //타이틀
//        titleLabel.snp.makeConstraints { make in
//            make.top.leading.equalToSuperview()
//        }
//        
////        outerStackView.snp.makeConstraints { make in
//////            make.top.equalToSuperview().offset(8)
//////            make.horizontalEdges.equalToSuperview().inset(16)
////            make.top.equalTo(titleLabel.snp.bottom).offset(16)
////            make.horizontalEdges.equalToSuperview()
////            make.bottom.equalToSuperview()
////            make.height.equalTo(112)
////        }
//
//        outerView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(16)
//            make.horizontalEdges.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.height.equalTo(112)
//        }
//        
//        leftStackView.snp.makeConstraints { make in
////            make.width.equalToSuperview().multipliedBy(0.5)
//            make.leading.verticalEdges.equalToSuperview()
//            make.width.equalTo(rightStackView)
//            make.trailing.equalTo(rightStackView.snp.leading).offset(-8)
//        }
//        
//        rightStackView.snp.makeConstraints { make in
////            make.width.equalToSuperview().multipliedBy(0.5)
//            make.trailing.verticalEdges.equalToSuperview()
//        }
//        
//        sesacTitleView.snp.makeConstraints { make in
//            make.height.equalTo(144)
//            make.edges.equalToSuperview()
//        }
//        //스터디
//        studyLabel.snp.makeConstraints { make in
//            make.top.leading.equalToSuperview()
//        }
//        collectionView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.top.equalTo(studyLabel.snp.bottom).offset(16)
//            make.bottom.equalToSuperview()
//        }
//        studyView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        //리뷰
//        moreReviewButton.snp.makeConstraints { make in
//            make.top.trailing.equalToSuperview()
//            make.size.equalTo(12)
//        }
//        reviewLabel.snp.makeConstraints { make in
//            make.leading.top.equalToSuperview()
//        }
//        textView.snp.makeConstraints { make in
//            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
//            make.horizontalEdges.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//        reviewView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        //토탈
//        finalStackView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(24)
//            make.horizontalEdges.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-16)
//        }
//    }
//}
