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
            .drive(mainView.tableView.rx.items(cellIdentifier: AroundSesacTableViewCell.identifier, cellType: AroundSesacTableViewCell.self)) { [weak self] row, element, cell in
        

                guard let backImage = BackgroundImage(rawValue: element.background)?.imageName,
                      let sesacImage = UserProfileImage(rawValue: element.sesac)?.image,
                let reviewIsEmpty = self?.viewModel.checkReviewEmpty(reviews: element.reviews) else { return }
                
//                cell.nameView.clearButton.tag = row
//                cell.nameView.clearButton.addTarget(self, action: #selector(self?.touchToggleButton(_:)), for: .touchUpInside)
//                cell.nameView.clearButton.isSelected ? cell.setUpView(collapsed: false) : cell.setUpView(collapsed: true)
                
                cell.setUpView(collapsed: !cell.nameView.clearButton.isSelected)
                cell.backgroundImageView.image = UIImage(named: backImage)
                cell.sesacImageView.image = UIImage(named: sesacImage)
                cell.nameView.nameLabel.text = element.nick
                for i in 0..<element.reputation.count {
                    if element.reputation[i] == 0 {
                        continue
                    }
                    switch i {
                    case 0:
                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.goodButton, status: .enable)
                    case 1:
                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.timeButton, status: .enable)
                    case 2:
                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.fastButton, status: .enable)
                    case 3:
                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.kindButton, status: .enable)
                    case 4:
                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.expertButton, status: .enable)
                    case 5:
                        self?.changeSelectedButtonColor(button: cell.sesacTitleView.helpfulButton, status: .enable)
                    default:
                        break
                    }
                }
                if reviewIsEmpty {
                    cell.reviewView.detailButton.isHidden = true
                } else {
                    cell.reviewView.label.text = element.reviews[0]
                }
                
//                cell.nameView.clearButton.rx.tap
//                    .bind(onNext: { [weak self] _ in
//                        print(element.nick)
//                        print("탭한거 iscolla \(cell.isCollapsed.value)", row)
////                        cell.isCollapsed = !cell.isCollapsed
//                        cell.isCollapsed.accept(!cell.isCollapsed.value)
//                        print("탭한거 iscolla \(cell.isCollapsed.value)", row)
//                    })
//                    .disposed(by: cell.disposeBag)
//
//                cell.isCollapsed
//                    .bind(onNext: { [weak self] value in
//                        print("이스콜랍바뀜")
//                        cell.setUpView(collapsed: value)
//                    })
//                    .disposed(by: cell.disposeBag)
//
                //요청하기 버튼
                cell.requestButton.rx.tap
                    .bind(onNext: { [weak self] _ in
                        print("요청하기 탭탭")
                        print(element.nick)
                        self?.viewModel.studyRequest(uid: element.uid)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        viewModel.sesacList
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] value in
                //개수 체크해서 0이면 noSesacView띄우고 tableviewhidden
                self?.checkListCount(list: value)
            })
            .disposed(by: disposeBag)
    }
}

extension AroundSesacViewController {
//    private func changeTitleButtonColor(button: UIButton, status: ButtonStatus) {
//        switch status {
//        case .enable:
//            button.layer.borderWidth = 0
//            button.configuration?.baseBackgroundColor = .brandGreen
//            button.configuration?.baseForegroundColor = .white
//        case .disable:
//            button.layer.borderWidth = 1
//            button.configuration?.baseBackgroundColor = .clear
//            button.configuration?.baseForegroundColor = .black
//        }
//    }
    private func checkListCount(list: [FromQueueDB]) {
        let emptyValue = viewModel.checkListEmpty(list: list)
        mainView.tableView.isHidden = emptyValue
        mainView.noSesacView.isHidden = !emptyValue
    }
}

extension AroundSesacViewController {
    @objc private func touchToggleButton(_ sender: UIButton) {
        print(sender.tag)
//        sender.isSelected = !sender.isSelected
        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ProfileTableViewCell else { return }
        print(cell.isSelected)
//        cell.isSelected = !cell.isSelected
//        cell.setUpView(collapsed: !cell.isSelected)
        mainView.tableView.reloadData()
    }
//    @objc private func tapRequestButton(_ sender: UIButton) {
//        guard let cell = mainView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? ProfileTableViewCell else { return }
//    }
}
