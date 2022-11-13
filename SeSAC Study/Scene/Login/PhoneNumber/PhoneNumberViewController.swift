//
//  PhoneNumberViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift
import Toast

final class PhoneNumberViewController: BaseViewController {
    
    private var mainView = PhoneNumberView(message: LoginText.phoneNumber.message, detailMessage: LoginText.phoneNumber.detailMessage, buttonTitle: ButtonTitle.authButtonTitle)
    private let viewModel = PhoneNumberViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setIsFirst()
        bind()
    }
    
    override func configure() {
        super.configure()

    }
    
    private func bind() {
        let input = PhoneNumberViewModel.Input(numberText: mainView.numberTextField.rx.text, tapDoneButton: mainView.doneButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.numberText
            .bind(onNext: { [weak self] value in
                self?.viewModel.setPhoneNumber(number: value)
                self?.viewModel.checkPhoneNumber(number: value)
            })
            .disposed(by: disposeBag)

        output.phoneNumber
            .drive(onNext: { [weak self] value in
                self?.mainView.numberTextField.text = value.pretty()
            })
            .disposed(by: disposeBag)
        
        output.buttonStatus
            .drive(onNext: { [unowned self] value in
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)

        output.tapDoneButton
            .bind(onNext: { [weak self] _ in
                self?.viewModel.sendPhoneAuth()
            })
            .disposed(by: disposeBag)
        
        output.sendAuthCheck
            .drive(onNext: { [weak self] value in
                self?.authCheck(value: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func authCheck(value: AuthCheck) {
        switch value {
        case .wrongNumber, .fail, .manyRequest:
            presentToast(view: mainView, message: value.message)
        case .success:
            presentToast(view: mainView, message: value.message)
            viewModel.savePhoneNumber(value: mainView.numberTextField.text ?? "")
            let vc = PhoneAuthViewController()
            transition(vc, transitionStyle: .push)
        }
    }
 }
