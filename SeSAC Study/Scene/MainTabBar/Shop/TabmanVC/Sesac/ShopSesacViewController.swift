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
        viewModel.requestProductData()
    }

    override func configure() {
        super.configure()

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
                        print("\(item)")
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
    }
}

extension ShopSesacViewController {
    
    private func changePriceButton(button: UIButton, item: Int, price: String) {
        if viewModel.checkPurchase(item: item) {
            button.configuration?.baseBackgroundColor = .grayTwo
            button.configuration?.baseForegroundColor = .graySeven
            button.configuration?.title = "보유"
        } else {
            button.configuration?.baseBackgroundColor = .brandGreen
            button.configuration?.baseForegroundColor = .white
            button.configuration?.title = "\(price)"
        }
    }
    
    private func setCurrentImage() {
        
    }
    
}
