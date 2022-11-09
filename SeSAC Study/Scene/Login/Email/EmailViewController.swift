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
    }
    
    private func bind() {
        mainView.emailTextField.rx.text
            .orEmpty
            .bind(onNext: { [weak self] value in
                self?.viewModel.checkEmail(email: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.buttonStatus
            .asDriver(onErrorJustReturn: .disable)
            .drive(onNext: { [unowned self] value in
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.setEmailStatus()
            })
            .disposed(by: disposeBag)
        
        viewModel.emailStatus
            .asDriver(onErrorJustReturn: .invalid)
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
            //MARK: 화면전환
            let vc = GenderViewController()
            transition(vc, transitionStyle: .push)
        case .invalid:
            presentToast(view: mainView, message: status.message)
        }
    }
}
