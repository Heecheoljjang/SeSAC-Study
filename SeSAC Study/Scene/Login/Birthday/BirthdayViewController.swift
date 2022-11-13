//
//  BirthdayViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import RxCocoa
import RxSwift

final class BirthdayViewController: ViewController {
    
    private var mainView = BirthdayView(message: LoginText.birthday.message, detailMessage: LoginText.birthday.detailMessage, buttonTitle: ButtonTitle.next)
    private let disposeBag = DisposeBag()
    private let viewModel = BirthdayViewModel()
    
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
            let birth = viewModel.fetchBirth()
            viewModel.setBirthday(date: birth)
            mainView.datePicker.date = birth
        }
    }
    
    func bind() {
        let input = BirthdayViewModel.Input(date: mainView.datePicker.rx.date, tapDoneButton: mainView.doneButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.selectedDate
            .bind(onNext: { [weak self] value in
                self?.viewModel.setBirthday(date: value)
            })
            .disposed(by: disposeBag)
        
        output.birthday
            .drive(onNext: { [weak self] value in
                self?.setTextField(date: value)
                self?.viewModel.setBirth(date: value)
                self?.viewModel.checkAge(date: value)
            })
            .disposed(by: disposeBag)
        
        output.buttonStatus
            .drive(onNext: { [unowned self] value in
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)
        
        output.tapDoneButton
            .bind(onNext: { [weak self] _ in
                self?.viewModel.setCheckStatus()
            })
            .disposed(by: disposeBag)
        
        output.checkStatus
            .drive(onNext: { [weak self] value in
                self?.checkStatus(status: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentKeyboard() {
        mainView.hiddenTextField.becomeFirstResponder()
    }
    
    private func setTextField(date: Date) {
        mainView.yearView.dateTextField.text = date.dateToString(type: .year)
        mainView.monthView.dateTextField.text = date.dateToString(type: .month)
        mainView.dayView.dateTextField.text = date.dateToString(type: .day)
    }
    
    private func checkStatus(status: BirthdayStatus) {
        switch status {
        case .enable:
            let vc = EmailViewController()
            transition(vc, transitionStyle: .push)
        case .disable:
            presentToast(view: mainView, message: BirthdayStatus.disable.message)
        }
    }
}
