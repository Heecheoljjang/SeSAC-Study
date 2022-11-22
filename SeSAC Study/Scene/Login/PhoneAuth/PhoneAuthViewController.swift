//
//  PhoneAuthViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift

final class PhoneAuthViewController: ViewController {
    
    private var mainView = PhoneAuthView(message: LoginText.phoneAuth.message, detailMessage: LoginText.phoneAuth.detailMessage, buttonTitle: ButtonTitle.authCheckButtonTitle)
    private let disposeBag = DisposeBag()
    let viewModel = PhoneAuthViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentToast(view: mainView, message: AuthCodeCheck.sendCode)
    }
    
    override func configure() {
        super.configure()
        
    }
    
    func bind() {
        let input = PhoneAuthViewModel.Input(authCode: mainView.authTextField.rx.text, tapDoneButton: mainView.doneButton.rx.tap, tapRetryButton: mainView.retryButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.authCode
            .bind(onNext: { [weak self] value in
                value ? self?.viewModel.setButtonStatus(value: ButtonStatus.enable) : self?.viewModel.setButtonStatus(value: ButtonStatus.disable)
            })
            .disposed(by: disposeBag)
        
        output.buttonStatus
            .drive(onNext: { [unowned self] value in
                self.changeNextButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)

        output.tapDoneButton
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                vc.viewModel.checkAuth(code: vc.mainView.authTextField.text ?? "")
            })
            .disposed(by: disposeBag)
        
        output.authCodeCheck
            .drive(onNext: { [weak self] value in
                self?.authCheck(value: value)
            })
            .disposed(by: disposeBag)
        
        output.errorStatus
            .drive(onNext: { [weak self] value in
                self?.checkStatus(value: value)
            })
            .disposed(by: disposeBag)
        
        output.tapRetryButton
            .bind(onNext: { [weak self] _ in
                self?.viewModel.requestAgain()
            })
            .disposed(by: disposeBag)
        
        output.phoneNumberCheck
            .asDriver(onErrorJustReturn: .fail)
            .drive(onNext: { [weak self] value in
                self?.authCodeCheck(value: value)
            })
            .disposed(by: disposeBag)
    }
    private func authCheck(value: AuthCodeCheck) {
        switch value {
        case .timeOut, .wrongCode, .fail:
            presentToast(view: mainView, message: value.message)
        case .success:
            viewModel.fetchIdToken()
        }
    }
    private func checkStatus(value: LoginError) {
        switch value {
        case .signUpSuccess:
            print("홈화면으로 전환")
            let main = MainTabBarController()
            changeRootViewController(viewcontroller: main, isTabBar: true)
        case .signUpRequired:
            print("회원가입")
            let vc = NicknameViewController()
            transition(vc, transitionStyle: .push)
        case .tokenError:
            print("토근다시가져오기")
            viewModel.fetchIdToken()
        default:
            print("나머지")
            presentToast(view: mainView, message: ErrorText.message)
        }
    }
    
    private func authCodeCheck(value: AuthCheck) {
        switch value {
        case .wrongNumber, .fail, .manyRequest:
            presentToast(view: mainView, message: value.message)
        case .success:
            presentToast(view: mainView, message: value.message)
        }
    }
}
