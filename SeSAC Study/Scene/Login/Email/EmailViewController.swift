//
//  EmailViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import RxCocoa
import RxSwift

final class EmailViewController: BaseViewController {
    
    private var mainView = EmailView(message: LoginText.email.message, detailMessage: LoginText.email.detailMessage, buttonTitle: ButtonTitle.next)
    private let viewModel = EmailViewModel()
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
        
        presentKeyboard()
        
        //유저디폴트 nil이 아닐때만 텍스트필드에 세팅
        print("짜증나", viewModel.checkUserDefaultsExist())
        
        if viewModel.checkUserDefaultsExist() {
            setTextField()
        }
    }
    
    private func bind() {
        let input = EmailViewModel.Input(emailText: mainView.emailTextField.rx.text, doneButtonTap: mainView.doneButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.emailText
            .bind(onNext: { [weak self] value in
                print("이메일: \(value)")
                self?.viewModel.checkEmail(email: value)
            })
            .disposed(by: disposeBag)

        output.buttonStatus
            .drive(onNext: { [unowned self] value in
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)

        output.doneButtonTap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.setEmailStatus()
            })
            .disposed(by: disposeBag)

        output.emailStatus
            .drive(onNext: { [weak self] value in
                self?.checkStatus(status: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentKeyboard() {
        mainView.emailTextField.becomeFirstResponder()
    }
    
    private func checkStatus(status: EmailStatus) {
        switch status {
        case .valid:
            viewModel.setEmail(email: mainView.emailTextField.text ?? "")
            //MARK: 화면전환
            let vc = GenderViewController()
            transition(vc, transitionStyle: .push)
        case .invalid:
            presentToast(view: mainView, message: status.message)
        }
    }
    
    private func setTextField() {
        print("setTextField", viewModel.fetchEmail())
        mainView.emailTextField.text = viewModel.fetchEmail()
    }
}
