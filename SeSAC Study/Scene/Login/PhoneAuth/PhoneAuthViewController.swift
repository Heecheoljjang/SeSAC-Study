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
        
        mainView.authTextField.rx.text
            .orEmpty
            .bind { [weak self] value in
                self?.viewModel.setAuthCode(code: value) //코드 값 입력
            }
            .disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.checkAuth() //코드 맞는지 확인
            })
            .disposed(by: disposeBag)
        
        viewModel.authCodeCheck
            .asDriver(onErrorJustReturn: .fail)
            .drive(onNext: { [weak self] value in
                self?.authCheck(value: value)
            })
            .disposed(by: disposeBag)
    }
    private func authCheck(value: AuthCodeCheck) {
        switch value {
        case .timeOut, .wrongCode, .fail:
            presentToast(view: mainView, message: value.message)
        case .success:
            presentToast(view: mainView, message: value.message)
            //MARK: - 여기서 사용자 정보 확인해서 있으면 홈 화면으로, 정보가 없으면 닉네임 입력 화면으로 전환
            
            //MARK: 일단 닉네임 화면으로
            let vc = NicknameViewController()
            transition(vc, transitionStyle: .push)
        }
    }
}
