//
//  ShopBackgroundViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/04.
//

import UIKit
import RxSwift
import RxCocoa

final class ShopBackgroundViewController: ViewController {
    
    private var mainView = ShopBackgroundView()
    private let viewModel = ShopBackgroundViewModel()
    private let disposeBag = DisposeBag()
    
    weak var delegate: ShopBackgroundDelegate?
    
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
        viewModel.shopBackgroundData
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.tableView.rx.items(cellIdentifier: ShopBackgroundTableViewCell.identifier, cellType: ShopBackgroundTableViewCell.self)) { [weak self] row, element, cell in

                cell.backgroundImageView.image = UIImage(named: element.imageName)
                cell.nameLabel.text = element.title
                self?.changePriceButton(button: cell.priceButton, item: row, price: element.price)
                cell.infoLabel.text = element.info
                
                cell.priceButton.rx.tap
                    .bind(onNext: { [weak self] _ in
                        self?.viewModel.tapPriceButton(index: row)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        viewModel.products
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] value in
                self?.viewModel.createShopBackgroundData(products: value)
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

extension ShopBackgroundViewController {
    
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
