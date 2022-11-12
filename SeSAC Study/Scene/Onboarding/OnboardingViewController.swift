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
                cell.messageLabel.attributedText = element.message.makeAttributedSpacing(spacing: 8, text: element.colorText)
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
        
        mainView.startButton.rx.tap
            .bind(onNext: { _ in
                //전화번호 인증화면으로 루트뷰컨 바꾸고 1값주기
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let transition = CATransition()
                transition.type = .fade
                transition.duration = 0.3
                sceneDelegate?.window?.layer.add(transition, forKey: kCATransition)
                
                let nav = UINavigationController(rootViewController: PhoneNumberViewController())
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            })
            .disposed(by: disposeBag)
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}
