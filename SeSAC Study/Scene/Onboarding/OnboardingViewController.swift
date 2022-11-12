//
//  OnboardingViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {
    
    private var mainView = OnboardingView()
    private let viewModel = OnboardingViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        viewModel.onboardingData
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: OnboardingCollectionViewCell.identifier, cellType: OnboardingCollectionViewCell.self)) { item, element, cell in
                cell.messageLabel.text = element.message
                cell.imageView.image = UIImage(named: element.imageName)
            }
            .disposed(by: disposeBag)
        
        viewModel.onboardingData
            .bind(onNext: { [weak self] value in
                self?.mainView.pageControl.numberOfPages = value.count
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.contentOffset
            .map { $0.x }
            .withUnretained(self)
            .bind(onNext: { (vc, value) in
                guard let width = vc.mainView.window?.windowScene?.screen.bounds.width else { return }
                vc.mainView.pageControl.currentPage = vc.viewModel.pageControlPage(xOffset: value, width: width)
            })
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
