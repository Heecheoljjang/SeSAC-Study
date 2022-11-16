//
//  StudyCollectionView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import SnapKit

final class StudyTableViewCell: BaseTableViewCell {
    
    let studyLabel: UILabel = {
        let label = UILabel()
        label.text = CardViewSection.study.titleString
        label.font = UIFont(name: CustomFont.regular, size: 12)
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: StudyCollectionViewCell.identifier)
        view.backgroundColor = .red
//        view.isScrollEnabled = false
//        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: StudyTableViewCell.identifier)
    }
    
    override func configure() {
        super.configure()
        [studyLabel, collectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        studyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(studyLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            
            //MARK: - 다시 체크해야함(임시)
            make.bottom.equalToSuperview().offset(-24)
            make.height.equalTo(100)
        }
    }
}
