//
//  AroundSesacViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa

final class AroundSesacViewController: ViewController {
    
    private var mainView = AroundSesacView()
    private let viewModel = AroundSesacViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.startSeSacSearch()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("바이루")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("진짜 바이")
    }
    
    override func configure() {
        super.configure()
        
        mainView.tableView.isScrollEnabled = true
    }
    
    func bind() {
        viewModel.sesacList
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.tableView.rx.items(cellIdentifier: ProfileTableViewCell.identifier, cellType: ProfileTableViewCell.self)) { [weak self] row, element, cell in
                
                guard let backImage = BackgroundImage(rawValue: element.background)?.imageName,
                      let sesacImage = UserProfileImage(rawValue: element.sesac)?.image,
                let reviewIsEmpty = self?.viewModel.checkReviewEmpty(reviews: element.reviews) else { return }
                
                cell.backgroundImageView.image = UIImage(named: backImage)
                cell.sesacImageView.image = UIImage(named: sesacImage)
                cell.nameView.nameLabel.text = element.nick
                for i in 0..<element.reputation.count {
                    if element.reputation[i] == 0 {
                        continue
                    }
                    switch i {
                    case 0:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.goodButton, status: .enable)
                    case 1:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.timeButton, status: .enable)
                    case 2:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.fastButton, status: .enable)
                    case 3:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.kindButton, status: .enable)
                    case 4:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.expertButton, status: .enable)
                    case 5:
                        self?.changeTitleButtonColor(button: cell.sesacTitleView.helpfulButton, status: .enable)
                    default:
                        break
                    }
                }
                if reviewIsEmpty {
                    cell.reviewView.detailButton.isHidden = true
                }
                
            }
            .disposed(by: disposeBag)
    }
}

extension AroundSesacViewController {
    private func changeTitleButtonColor(button: UIButton, status: ButtonStatus) {
        switch status {
        case .enable:
            button.layer.borderWidth = 0
            button.configuration?.baseBackgroundColor = .brandGreen
            button.configuration?.baseForegroundColor = .white
        case .disable:
            button.layer.borderWidth = 1
            button.configuration?.baseBackgroundColor = .clear
            button.configuration?.baseForegroundColor = .black
        }
    }
}
