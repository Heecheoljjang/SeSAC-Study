//
//  ShopSesacViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ShopSesacViewController: ViewController {
    
    private var mainView = ShopSesacView()
    private let viewModel = ShopSesacViewModel()
    private let disposeBag = DisposeBag()
    
    weak var delegate: ShopSesacDelegate?
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPurchaseInfo()
    }
    
    func bind() {
        viewModel.shopSesacData
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.collectionView.rx.items(cellIdentifier: ShopSesacCollectionViewCell.identifier, cellType: ShopSesacCollectionViewCell.self)) { [weak self] item, element, cell in

                cell.sesacImageView.image = UIImage(named: element.imageName)
                cell.nameLabel.text = element.title
                self?.changePriceButton(button: cell.priceButton, item: item, price: element.price)
                cell.infoLabel.text = element.info
                
                cell.priceButton.rx.tap
                    .bind(onNext: { [weak self] _ in
                        //MARK: 인앱결제
                        /*
                         지금 맨 앞에 기본 새싹이 있으므로 product배열에서는 인덱스가 하나씩 뒤에 있음.
                         */
                        self?.viewModel.tapPriceButton(index: item)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        viewModel.products
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] value in
                self?.viewModel.createShopSesacData(products: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.purchaseStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] value in
                self?.checkPurchaseStatus(status: value)
            })
            .disposed(by: disposeBag)
    }
}

extension ShopSesacViewController {
    
    private func changePriceButton(button: UIButton, item: Int, price: String) {
        if viewModel.checkPurchase(item: item) {
            button.configuration?.baseBackgroundColor = .grayTwo
            button.configuration?.baseForegroundColor = .graySeven
            button.configuration?.title = "보유"
            button.isUserInteractionEnabled = false
        } else {
            button.configuration?.baseBackgroundColor = .brandGreen
            button.configuration?.baseForegroundColor = .white
            button.configuration?.title = "\(price)"
            button.isUserInteractionEnabled = true
        }
    }
    
    private func checkPurchaseStatus(status: ShopNetworkError.PurchaseShopItem) {
        switch status {
        case .purchaseSuccess:
            presentToast(view: mainView, message: status.message)
            viewModel.fetchPurchaseInfo()
        default:
            presentToast(view: mainView, message: status.message)
        }
    }
}
