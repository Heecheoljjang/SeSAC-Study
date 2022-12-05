//
//  ShopSesacView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/05.
//

import UIKit
import SnapKit

final class ShopSesacView: BaseView {
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayTwo
        return view
    }()
    
    let collectionView: DynamicCollectionView = {
        let view = DynamicCollectionView(frame: CGRect.zero, collectionViewLayout: createLayout())
        view.register(ShopSesacCollectionViewCell.self, forCellWithReuseIdentifier: ShopSesacCollectionViewCell.identifier)
        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [lineView, collectionView].forEach {
            addSubview($0)
        }
    }
    override func setUpConstraints() {
        super.setUpConstraints()
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}

extension ShopSesacView {
    private static func createLayout() -> UICollectionViewCompositionalLayout {
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(12)
        //sections
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        //return
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        
        return layout
    }
}
