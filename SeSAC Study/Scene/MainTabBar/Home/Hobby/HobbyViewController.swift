//
//  HobbyViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/18.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation

final class HobbyViewController: ViewController {
    
    private var mainView = HobbyView()
    private let viewModel = HobbyViewModel()
    private let disposeBag = DisposeBag()
    
    let data = ["123213", "kfvnk", "123123vb"]
    let daf = ["asdcds", "fdsaf","safdsasdfasdfdsaaf","saf","ssaf","safdsasdfsadfasdaf","safdsaf","safdsaf","asdcds", "fdsaf","safdsasdfasdfdsaaf","saf","ssaf","safdsasdfsadfasdaf","safdsaf","safdsaf","asdcds", "fdsaf","safdsasdfasdfdsaaf","saf","ssaf","safdsasdfsadfasdaf","safdsaf","safdsaf","asdcds", "fdsaf","safdsasdfasdfdsaaf","saf","ssaf","safdsasdfsadfasdaf","safdsaf","safdsaf","asdcds", "fdsaf","safdsasdfasdfdsaaf","saf","ssaf","safdsasdfsadfasdaf","safdsaf","safdsaf","asdcds", "fdsaf","safdsasdfasdfdsaaf","saf","ssaf","safdsasdfsadfasdaf","safdsaf","safdsaf","asdcds", "fdsaf","safdsasdfasdfdsaaf","saf","ssaf","safdsasdfsadfasdaf","safdsaf","safdsaf","asdcds", "fdsaf","safdsasdfasdfdsaaf","saf","ssaf","safdsasdfsadfasdaf","safdsaf","safdsaf","asdcds", "fdsaf","safdsasdfasdfdsaaf","saf","ssaf","safdsasdfsadfasdaf","safdsaf","safdsaf"]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func configure() {
        super.configure()
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mainView.searchBar)
        
        mainView.MyListCollectionView.delegate = self
        mainView.MyListCollectionView.dataSource = self
        mainView.AroundCollectionView.delegate = self
        mainView.AroundCollectionView.dataSource = self
    }
    
    func bind() {

        viewModel.recommendList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
        
        viewModel.sesacStudyList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
        
        viewModel.mystudyList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
        
        viewModel.searchList
            .asDriver(onErrorJustReturn: SesacSearch(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
            .drive(onNext: { [weak self] value in
                print(value)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentLocation
            .asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
            .drive(onNext: { [weak self] value in
                self?.viewModel.fetchSeSacSearch(location: value)
            })
            .disposed(by: disposeBag)
        
    }
}

extension HobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case mainView.AroundCollectionView:
            return 2
        default:
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.AroundCollectionView:
            if section == 0 {
//                return viewModel.fetchRecommendListCount()
                return 0
            } else {
//                return viewModel.fetchSesacStudyListCount()
                return 0
            }
        default:
//            return viewModel.fetchMyStudyListCount()
            return 8
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case mainView.AroundCollectionView:
            if indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell else { return UICollectionViewCell() }
                cell.titleLabel.text = daf[indexPath.item]
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacStudyCollectionViewCell.identifier, for: indexPath) as? SesacStudyCollectionViewCell else { return UICollectionViewCell() }
                cell.titleLabel.text = daf[indexPath.item]
                return cell
            }
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyListCollectionViewCell.identifier, for: indexPath) as? MyListCollectionViewCell else { return UICollectionViewCell() }
            cell.titleLabel.text = "fasdfgg"
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
