//
//  HobbyView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/19.
//

import UIKit
import SnapKit

final class HobbyView: BaseView {
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 1000, height: 0))
        bar.placeholder = PlaceHolder.searchBar
        return bar
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let aroundLabel: UILabel = {
        let label = UILabel()
        label.text = SearchStudySection.around
        label.font = UIFont(name: CustomFont.regular, size: 12)
        return label
    }()
    
    let AroundCollectionView: DynamicCollectionView = {
        
        let view = DynamicCollectionView(frame: CGRect.zero, collectionViewLayout: createLayout())
        view.isScrollEnabled = false
        view.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        view.register(SesacStudyCollectionViewCell.self, forCellWithReuseIdentifier: SesacStudyCollectionViewCell.identifier)
        return view
    }()
    
    let myListLabel: UILabel = {
        let label = UILabel()
        label.text = SearchStudySection.myList
        label.font = UIFont(name: CustomFont.regular, size: 12)
        return label
    }()
    
    let MyListCollectionView: DynamicCollectionView = {
        let view = DynamicCollectionView(frame: CGRect.zero, collectionViewLayout: createLayout())
        view.isScrollEnabled = false
        view.register(MyListCollectionViewCell.self, forCellWithReuseIdentifier: MyListCollectionViewCell.identifier)
        return view
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .brandGreen
        configuration.cornerStyle = .medium
        configuration.title = ButtonTitle.searchSesac
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [aroundLabel, AroundCollectionView, myListLabel, MyListCollectionView].forEach {
            contentView.addSubview($0)
        }
        scrollView.addSubview(contentView)
        [scrollView, searchButton].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        aroundLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(16)
        }
        AroundCollectionView.snp.makeConstraints { make in
            make.top.equalTo(aroundLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(40)
        }
        myListLabel.snp.makeConstraints { make in
            make.top.equalTo(AroundCollectionView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
        }
        MyListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(myListLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(200)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
    }
    private static func createLayout() -> UICollectionViewCompositionalLayout {
        //item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(200),
            heightDimension: .absolute(32)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(32)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
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
