//
//  EmailViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import RxCocoa
import RxSwift

final class EmailViewController: ViewController {
    
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
                
        if viewModel.checkUserDefaultsExist() {
            setTextField()
        }
    }
    
    func bind() {
        let input = EmailViewModel.Input(emailText: mainView.emailTextField.rx.text, tapDoneButton: mainView.doneButton.rx.tap)
        let output = viewModel.transform(input: input)

        output.emailText

        output.buttonStatus
            .drive(onNext: { [unowned self] value in
                self.changeNextButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)

        output.tapDoneButton

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
