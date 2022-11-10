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
        
//        mainView.authTextField.rx.text
//            .orEmpty
//            .bind { [weak self] value in
//                self?.viewModel.setAuthCode(code: value) //코드 값 입력
//            }
//            .disposed(by: disposeBag)
//
        mainView.doneButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                //버튼 탭했을때 코드 확인해서 authCodeCheck값 바꿔주기
                print(vc.mainView.authTextField.text)
                print(vc.mainView.authTextField.text ?? "")
                print(vc.mainView.authTextField.text!)
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
                //화면전환하면될듯
                self?.checkStatus(value: value)
            })
            .disposed(by: disposeBag)
        

    }
    private func authCheck(value: AuthCodeCheck) {
        switch value {
        case .timeOut, .wrongCode, .fail, .sendCode:
            presentToast(view: mainView, message: value.message)
        case .success:
            viewModel.fetchIdToken() //인증번호가 맞으니까 호출
        }
    }
    private func checkStatus(value: NetworkErrorString) {
        switch value {
        case .signUpSuccess: //코드 200이므로 로그인성공 -> 홈 화면으로 전환
            print("홈화면으로 전환")
        case .signUpRequired:
            //닉네임 입력으로
            let vc = NicknameViewController()
            transition(vc, transitionStyle: .push)
        default:
            presentToast(view: mainView, message: ErrorText.message)
        }
    }
}

/*
 인증번호 옴 -> 텍스트필드 입력할때 6자리 넘어야 buttonStatus enable로 바꿔줘서 색 바뀜.
 ->
 */
