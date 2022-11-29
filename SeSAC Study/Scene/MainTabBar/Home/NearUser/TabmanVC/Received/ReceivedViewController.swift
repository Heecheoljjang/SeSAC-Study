//
//  ReceivedViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa

final class ReceivedViewController: ViewController {
    
    private var mainView = ReceivedView()
    private let viewModel = ReceivedViewModel()
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

    override func configure() {
        super.configure()
        
        mainView.tableView.isScrollEnabled = true
    }
    
    func bind() {
        viewModel.sesacList
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.tableView.rx.items(cellIdentifier: ReceivedTableViewCell.identifier, cellType: ReceivedTableViewCell.self)) { [weak self] row, element, cell in
                
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
                //수락하기 버튼
                cell.requestButton.rx.tap
                    .bind(onNext: { [weak self] _ in
                        print("수락하기 탭탭")
                        print(element.nick)
                        self?.viewModel.setOtherUid(uid: element.uid)
                        self?.showCustomAlert(title: CustomAlert.studyAccept.title, message: CustomAlert.studyAccept.message)
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
        
        viewModel.acceptStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] value in
                self?.checkAcceptStatus(status: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.myQueueStatus
            .asDriver(onErrorJustReturn: MyQueueState(dodged: 0, matched: 0, reviewed: 0, matchedNick: nil, matchedUid: nil))
            .drive(onNext: { [weak self] data in
                self?.checkMyQueueStatus(data: data)
            })
            .disposed(by: disposeBag)
    }
}

extension ReceivedViewController {

    private func checkListCount(list: [FromQueueDB]) {
        let emptyValue = viewModel.checkListEmpty(list: list)
        mainView.tableView.isHidden = emptyValue
        mainView.noSesacView.isHidden = !emptyValue
    }
    
    private func checkAcceptStatus(status: StudyAcceptError) {
        switch status {
        case .acceptSuccess:
            let vc = ChattingViewController()
            transition(vc, transitionStyle: .push)
        case .alreadyMatched:
            presentToast(view: mainView, message: status.message)
            viewModel.fetchMyQueueState()
        default:
            presentToast(view: mainView, message: status.message)
        }
    }
    
    private func checkMyQueueStatus(data: MyQueueState) {
        switch data.matched {
        case 1:
            guard let nick = data.matchedNick else { return }
            presentHandlerToast(view: mainView, message: "\(nick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let chattingVC = ChattingViewController()
                    chattingVC.title = nick
                    self.transition(chattingVC, transitionStyle: .push)
                }
            }
        default:
            //에러발생했다고 띄우기
            presentToast(view: mainView, message: StudyRequestError.tokenError.message)
        }
    }
}

extension ReceivedViewController: CustomAlertDelegate {
    func ok() {
        //MARK: accept통신
        guard let uid = UserDefaultsManager.shared.fetchValue(type: .otherUid) as? String else { return }
        viewModel.studyAccept(uid: uid)
    }
    
    func cancel() {
        print("취소누르고 아무일도 안일어남")
    }
}


extension ReceivedViewController {
    private func showCustomAlert(title: String, message: String) {
        let alertVC = CustomAlertViewController()
        alertVC.mainView.titleLabel.text = title
        alertVC.delegate = self
        alertVC.mainView.messagelabel.text = message
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overFullScreen
        present(alertVC, animated: true)
    }
}
