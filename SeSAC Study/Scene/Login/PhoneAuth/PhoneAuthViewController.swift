//
//  PhoneAuthViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift

final class PhoneAuthViewController: BaseViewController {
    
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
        
        presentToast(view: mainView, message: AuthCodeCheck.sendCode.message)
    }
    
    override func configure() {
        super.configure()
        
    }
    
    private func bind() {
        mainView.authTextField.rx.text
            .orEmpty
            .map { $0.count >= 6 }
            .bind(onNext: { [weak self] value in
                value ? self?.viewModel.setButtonStatus(value: ButtonStatus.enable) : self?.viewModel.setButtonStatus(value: ButtonStatus.disable)
            })
            .disposed(by: disposeBag)
        
        viewModel.buttonStatus
            .asDriver(onErrorJustReturn: ButtonStatus.disable)
            .drive(onNext: { [unowned self] value in
                //버튼이 true면 색 바꿔주기
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)

        mainView.doneButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                //버튼 탭했을때 코드 확인해서 authCodeCheck값 바꿔주기
                vc.viewModel.checkAuth(code: vc.mainView.authTextField.text ?? "")
            })
            .disposed(by: disposeBag)
        
        viewModel.authCodeCheck
            .asDriver(onErrorJustReturn: .fail)
            .drive(onNext: { [weak self] value in
                self?.authCheck(value: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] value in
                self?.checkStatus(value: value)
            })
            .disposed(by: disposeBag)
        
        mainView.retryButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.requestAgain()
            })
            .disposed(by: disposeBag)
    }
    private func authCheck(value: AuthCodeCheck) {
        switch value {
        case .timeOut, .wrongCode, .fail, .sendCode:
            presentToast(view: mainView, message: value.message)
        case .success:
            viewModel.fetchIdToken()
        }
    }
    private func checkStatus(value: NetworkErrorString) {
        switch value {
        case .signUpSuccess: //코드 200이므로 로그인성공 -> 홈 화면으로 전환
            print("홈화면으로 전환")
        case .signUpRequired:
            print("회원가입")
            let vc = NicknameViewController()
            transition(vc, transitionStyle: .push)
        case .tokenError:
            //다시 요청하기
            viewModel.fetchIdToken()
        default:
            print("나머지")
            presentToast(view: mainView, message: ErrorText.message)
        }
    }
}
