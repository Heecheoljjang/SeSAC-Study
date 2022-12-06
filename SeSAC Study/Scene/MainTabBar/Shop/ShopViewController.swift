//
//  ShopViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import Tabman
import Pageboy
import RxSwift
import RxCocoa

final class ShopViewController: ViewController, ShopDelegate {

    private var mainView = ShopView()
    private let viewModel = ShopViewModel()
    private let disposeBag = DisposeBag()
    private let tabmanVC = ShopTabmanViewController()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.fetchCurrentSesacAndBackground()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configure() {
        super.configure()
        title = NavigationBarTitle.shop.title
        
        tabmanVC.view.frame = mainView.containerView.bounds
        addChild(tabmanVC)
        mainView.containerView.addSubview(tabmanVC.view)
        tabmanVC.didMove(toParent: self)
    }
    
    func bind() {
        mainView.saveButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //MARK: updateItem 통신
                self?.viewModel.updateItem() //인풋아웃풋으로 만들때 아예 뷰모델에서 처리하게 하면 좋을듯
            })
            .disposed(by: disposeBag)
        
        viewModel.updateStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] value in
                self?.checkUpdateStatus(status: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.sesacImage
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] value in
                //MARK: 새싹이미지 바꾸기 Annotation
                if let image = Annotation(rawValue: value)?.imageName {
                    self?.mainView.sesacImageView.image = UIImage(named: image)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.backgroundImage
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] value in
                //MARK: 배경 이미지 바꾸기
                if let image = BackgroundImage(rawValue: value)?.imageName {
                    self?.mainView.backgroundImageView.image = UIImage(named: image)
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension ShopViewController{
    func changeSesacImage(value: Int) {
        viewModel.setSesacImage(value: value)
    }
    
    func changeBackgroundImage(value: Int) {
        viewModel.setBackgroundImage(value: value)
    }
}

extension ShopViewController {
    private func checkUpdateStatus(status: ShopNetworkError.UpdateShopItem) {
        presentToast(view: mainView, message: status.message)
    }
}
