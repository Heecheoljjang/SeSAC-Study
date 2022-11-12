//
//  OnboardingView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import UIKit
import SnapKit

final class OnboardingView: BaseView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .grayFive
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = ButtonTitle.start
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .brandGreen
        configuration.cornerStyle = .medium
        button.configuration = configuration
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        
        [collectionView, pageControl, startButton].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-44)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-40)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-72)
        }
    }
}

