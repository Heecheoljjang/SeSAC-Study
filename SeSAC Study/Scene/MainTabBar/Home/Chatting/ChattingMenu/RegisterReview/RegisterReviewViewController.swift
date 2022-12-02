//
//  RegisterReviewViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/02.
//

import UIKit
import RxCocoa
import RxSwift
import RxKeyboard

final class RegisterReviewViewController: ViewController {
    
    private var mainView = RegisterReviewView()
    private let disposeBag = DisposeBag()
    private let viewModel = RegisterReviewViewModel()
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configure() {
        super.configure()
        
        mainView.askingLabel.text = "\(viewModel.fetchMatchedNick())님과의 스터디는 어떠셨나요?"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = true
        mainView.outerView.addGestureRecognizer(tapGesture)
    }
    
    func bind() {
        let input = RegisterReviewViewModel.Input(tapCancel: mainView.cancelButton.rx.tap,
                                                  buttonValue: viewModel.buttonValue,
                                                  keyboard: RxKeyboard.instance.visibleHeight,
                                                  tapGood: mainView.goodButton.rx.tap,
                                                  tapTime: mainView.timeButton.rx.tap,
                                                  tapFast: mainView.fastButton.rx.tap,
                                                  tapKind: mainView.kindButton.rx.tap,
                                                  tapExpert: mainView.expertButton.rx.tap,
                                                  tapHelpful: mainView.helpfulButton.rx.tap,
                                                  textViewText: mainView.textView.rx.text.orEmpty,
                                                  textViewEmptyStatus: viewModel.textViewIsEmpty,
                                                  tapRegisterButton: mainView.registerButton.rx.tap,
                                                  registerStatus: viewModel.registerStatus)
        let output = viewModel.transform(input: input)
        
        output.tapCancel
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                vc.transition(vc, transitionStyle: .dismiss)
            })
            .disposed(by: disposeBag)
        
        output.buttonValue
            .drive(onNext: { [weak self] value in
                self?.changeReviewButtonColor(value: value)
            })
            .disposed(by: disposeBag)
        
        output.tapGood
        output.tapTime
        output.tapFast
        output.tapKind
        output.tapExpert
        output.tapHelpful
        
        output.keyboard
            .drive(onNext: { [weak self] value in
                self?.changeConstraints(value: value)
            })
            .disposed(by: disposeBag)
        
        output.textViewIsEmpty
        
        output.textViewCount
            .withUnretained(self)
            .bind(onNext: { vc, value in
                if value {
                    vc.textViewRemoveLast(textView: vc.mainView.textView)
                }
            })
            .disposed(by: disposeBag)
        
        output.textViewEmptyStatus
            .drive(onNext: { [weak self] value in
                self?.checkTextViewIsEmpty(isEmpty: value)
            })
            .disposed(by: disposeBag)
        
        output.tapRegisterButton
            .withUnretained(self)
            .bind(onNext: { vc, _ in
                //MARK: 버튼 최소 한 개 이상 눌렸는지 확인하고 아닌 경우엔 toast
                vc.viewModel.checkReputationAllZero() ? vc.presentToast(view: vc.mainView, message: ToastMessage.noReviewSelected) : vc.viewModel.registerReview(comment: vc.mainView.textView.text)
            })
            .disposed(by: disposeBag)
        
        output.registerStatus
            .drive(onNext: { [weak self] value in
                self?.checkRegisterStatus(status: value)
            })
            .disposed(by: disposeBag)
    }
}

extension RegisterReviewViewController {
    private func changeReviewButtonColor(value: [ButtonStatus]) {
        for i in 0..<value.count {
            switch i {
            case 0:
                changeSelectedButtonColor(button: mainView.goodButton, status: value[i])
            case 1:
                changeSelectedButtonColor(button: mainView.timeButton, status: value[i])
            case 2:
                changeSelectedButtonColor(button: mainView.fastButton, status: value[i])
            case 3:
                changeSelectedButtonColor(button: mainView.kindButton, status: value[i])
            case 4:
                changeSelectedButtonColor(button: mainView.expertButton, status: value[i])
            case 5:
                changeSelectedButtonColor(button: mainView.helpfulButton, status: value[i])
            default:
                break
            }
        }
    }
    
    private func changeConstraints(value: CGFloat) {
        if value != 0 {
            mainView.outerView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().offset(-value-20)
            }
        } else {
            mainView.outerView.snp.remakeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    private func checkTextViewIsEmpty(isEmpty: EmptyStatus) {
        switch isEmpty {
        case .empty:
            mainView.registerButton.isUserInteractionEnabled = false
            changeNextButtonColor(button: mainView.registerButton, status: .disable)
        case .notEmpty:
            mainView.registerButton.isUserInteractionEnabled = true
            changeNextButtonColor(button: mainView.registerButton, status: .enable)
        }
    }
    
    private func textViewRemoveLast(textView: UITextView) {
        textView.text.removeLast()
        mainView.textView.resignFirstResponder()
    }
    
    private func checkRegisterStatus(status: RegisterError) {
        switch status {
        case .registerSuccess:
            let main = MainTabBarController()
            changeRootViewController(viewcontroller: main, isTabBar: true)
        default:
            presentToast(view: mainView, message: status.errorMessage)
        }
    }
}

extension RegisterReviewViewController {
    @objc private func dismissKeyboard() {
        mainView.outerView.endEditing(true)
    }
}
