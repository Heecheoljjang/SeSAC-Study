//
//  ChattingViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import SnapKit
import RealmSwift

final class ChattingViewController: ViewController {
    
    private var mainView = ChattingView()
    private let viewModel = ChattingViewModel()
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
        
        viewModel.fetchChat()
    }
    
    override func configure() {
        super.configure()
        
        navigationItem.leftBarButtonItem = mainView.backButton
        navigationItem.rightBarButtonItem = mainView.menuBarButton

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        mainView.tableView.addGestureRecognizer(tapGesture)
    }
    
    func bind() {
        mainView.backButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                //MARK: 홈 화면 이동
                vc.transition(vc, transitionStyle: .pop)
            })
            .disposed(by: disposeBag)
        mainView.menuBarButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //MARK: 메뉴띄우기
//                self?.showMenu()
                self?.viewModel.fetchMyQueueState()
            })
            .disposed(by: disposeBag)
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.setUpConstraints(height: height)
                UIView.animate(withDuration: 0.5) {
                    self?.mainView.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        mainView.textView.rx.text
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                print(vc.checkTextViewLine())
                if vc.checkTextViewLine() {
                    vc.mainView.textView.isScrollEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.myQueueStatus
            .asDriver(onErrorJustReturn: MyQueueState(dodged: 0, matched: 0, reviewed: 0, matchedNick: nil, matchedUid: nil))
            .drive(onNext: { [weak self] status in
                self?.checkMyStatus(status: status)
            })
            .disposed(by: disposeBag)
        
        mainView.menuView.cancelButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //myqueue상태 체크해서 커스텀얼럿띄우기
                self?.showCustomAlert()
            })
            .disposed(by: disposeBag)
        
        viewModel.dodgeStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] status in
                self?.checkDodgeStatus(status: status)
            })
            .disposed(by: disposeBag)
        
        //버튼 색
        mainView.textView.rx.text.orEmpty
            .map { $0.count > 0 }
            .bind(onNext: { [weak self] value in
                self?.checkSendButtonEnable(value: value)
            })
            .disposed(by: disposeBag)
        
        //채팅보내기
        mainView.sendButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.viewModel.sendChat(chat: vc.mainView.textView.text)
            })
            .disposed(by: disposeBag)
        
        //채팅 보낸 상태
        viewModel.sendChatStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] status in
                self?.checkSendChatStatus(status: status)
            })
            .disposed(by: disposeBag)
        
        //테이블뷰 세팅
        viewModel.totalChatData
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.tableView.rx.items) { [weak self] tableView, row, element in
                guard let uid = UserDefaultsManager.shared.fetchValue(type: .otherUid) as? String else { return UITableViewCell() }
                
                if element.from == uid {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChattingTableViewCell.identifier) as? YourChattingTableViewCell else { return UITableViewCell() }
                    
                    cell.dateLabel.text = "\(row):11"
                    cell.messageLabel.text = element.chat
                    
                    return cell
                } else {
                    
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChattingTableViewCell.identifier) as? MyChattingTableViewCell else { return UITableViewCell() }
                    cell.dateLabel.text = "\(row):22"
                    cell.messageLabel.text = element.chat
                    return cell
                }
            }.disposed(by: disposeBag)
    }
}

extension ChattingViewController {
    private func setUpConstraints(height: CGFloat) {
        switch height {
        case 0:
            //다시 돌아가기
            mainView.messageView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalTo(mainView.safeAreaLayoutGuide).offset(-16)
                make.height.greaterThanOrEqualTo(52)
            }
            mainView.tableView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(mainView.messageView.snp.top).offset(-12)
                make.top.equalTo(mainView.safeAreaLayoutGuide)
            }
        default:
            //올리기
            mainView.messageView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().offset(-height-16)
                make.height.greaterThanOrEqualTo(52)
            }
            mainView.tableView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(mainView.messageView.snp.top).offset(-12)
                make.top.equalTo(mainView.safeAreaLayoutGuide)
            }
        }
    }
    
    private func checkTextViewLine() -> Bool {
        return mainView.textView.checkNumberOfLines() == 4 ? true : false
    }
    
    private func showMenu() {
        //MARK: - 일단 애니메이션빼고
        mainView.menuView.isHidden = !mainView.menuView.isHidden
    }
    
    private func checkMyStatus(status: MyQueueState) {
        //스터디 취소를 기본으로 해놨기때문에 따로 설정 x
        if status.dodged == 1 || status.reviewed == 1 {
            mainView.menuView.cancelButton.configuration?.title = "스터디 종료"
            showMenu()
            return
        } else if status.matched == 1 {
            showMenu()
            return
        }
    }
    
    private func checkDodgeStatus(status: StudyDodgeError) {
        switch status {
        case .dodgeSuccess:
            //성공이면 홈화면으로
            transition(self, transitionStyle: .pop)
        default:
            presentToast(view: mainView, message: status.errorMessage)
        }
    }
    
    private func showCustomAlert() {
        let isMatched = viewModel.checkMyQueueStatus()
        let alertVC = CustomAlertViewController()
        alertVC.delegate = self
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overFullScreen
        print("이스매치드 \(isMatched)")
        switch isMatched {
        case true:
            alertVC.mainView.titleLabel.text = CustomAlert.matched.title
            alertVC.mainView.messagelabel.text = CustomAlert.matched.message
        case false:
            alertVC.mainView.titleLabel.text = CustomAlert.alreadyCanceled.title
            alertVC.mainView.messagelabel.text = CustomAlert.alreadyCanceled.message
        }
        present(alertVC, animated: true)
    }
    
    private func checkSendButtonEnable(value: Bool) {
        switch value {
        case true:
            mainView.sendButton.configuration?.image = UIImage(named: ImageName.greenButton)
            mainView.sendButton.isUserInteractionEnabled = true
        case false:
            mainView.sendButton.configuration?.image = UIImage(named: ImageName.sendButton)
            mainView.sendButton.isUserInteractionEnabled = false
        }
    }
    
    private func checkSendChatStatus(status: SendChattingError) {
        switch status {
        case .sendSuccess:
            //MARK: 응답값 디비에 저장 후 테이블뷰 갱신
            print("성공성공~")
        default:
            presentToast(view: mainView, message: status.message)
        }
    }
}

extension ChattingViewController: CustomAlertDelegate {
    func ok() {
        //취소 네트워킹, 종료인 경우엔 아마 그냥 닫는듯
        viewModel.cancelStudy()
    }
    func cancel() {
        print("아무것도 안하고")
    }
}

extension ChattingViewController {
    @objc private func dismissKeyboard() {
        mainView.messageView.endEditing(true)
    }
}
