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

        viewModel.searchList
            .asDriver(onErrorJustReturn: SesacSearch(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
            .drive(onNext: { [weak self] value in
                print(value)
                self?.viewModel.setStudyList(data: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.aroundStudyList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
                self?.mainView.AroundCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.myStudyList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] _ in
                self?.mainView.MyListCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.currentLocation
            .asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
            .drive(onNext: { [weak self] value in
                self?.viewModel.fetchSeSacSearch(location: value)
            })
            .disposed(by: disposeBag)
        
        mainView.searchBar.rx.searchButtonClicked
            .bind(onNext: { [weak self] _ in
                self?.appendMyStudyList()
            })
            .disposed(by: disposeBag)
    }
}

extension HobbyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
                return viewModel.fetchRecommendListCount()
            } else {
                return viewModel.fetchSesacStudyListCount()
            }
        default:
            return viewModel.fetchMyStudyListCount()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case mainView.AroundCollectionView:
            if indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell else { return UICollectionViewCell() }
                cell.titleLabel.text = viewModel.fetchRecommendListData(item: indexPath.item)
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacStudyCollectionViewCell.identifier, for: indexPath) as? SesacStudyCollectionViewCell else { return UICollectionViewCell() }
                cell.titleLabel.text = viewModel.fetchSesacStudyListData(item: indexPath.item)
                return cell
            }
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyListCollectionViewCell.identifier, for: indexPath) as? MyListCollectionViewCell else { return UICollectionViewCell() }
            cell.titleLabel.text = viewModel.fetchMyStudyListData(item: indexPath.item)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case mainView.AroundCollectionView:
            if viewModel.checkMyStudyListCountAlready() {
                presentToast(view: mainView, message: ToastMessage.tooMany)
                return
            }
            if indexPath.section == 0 {
                let study = viewModel.fetchRecommendListData(item: indexPath.item)
                appendSelectedStudy(study: study)
            } else {
                let study = viewModel.fetchSesacStudyListData(item: indexPath.item)
                appendSelectedStudy(study: study)
            }
        default:
            //myStudyList에서 제거
            viewModel.removeMyStudyListElement(item: indexPath.item)
        }
    }
}

extension HobbyViewController {
    private func appendSelectedStudy(study: String) {
        if viewModel.checkElementExist(study: study) {
            presentToast(view: mainView, message: ToastMessage.alreadyExistStudy)
            return
        }
        viewModel.appendMyStudyListElement(study: study)
    }
    
    private func appendMyStudyList() {
        mainView.searchBar.resignFirstResponder()
        //일단 리스트에 있는지부터 확인
        guard let text = mainView.searchBar.text else { return }
        mainView.searchBar.text = ""
        let studyArr = viewModel.createStringArray(text: text)
        
        if viewModel.checkAlreadyExist(list: studyArr) {
            presentToast(view: mainView, message: ToastMessage.alreadyExistStudy)
            return
        }
        //추가하면 8개가 넘는지 확인
        if viewModel.checkMyStudyListCount(list: studyArr) {
            presentToast(view: mainView, message: ToastMessage.tooMany)
            return
        }
        //현재 리스트에서 8자 이상이 있는지 확인
        if viewModel.checkTextCount(list: studyArr) {
            presentToast(view: mainView, message: ToastMessage.tooLong)
            return
        }
        //공백만 입력되었는지
        if viewModel.checkOnlyEmpty(list: studyArr) {
            presentToast(view: mainView, message: ToastMessage.tooShort)
            return
        }
        //myStudyList에 추가
        viewModel.appendMyStudyList(list: studyArr)
    }
}
