//
//  BirthdayViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import RxCocoa
import RxSwift

final class BirthdayViewController: BaseViewController {
    
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
    }
    
    private func bind() {
        
        mainView.datePicker.rx.date
            .bind(onNext: { [weak self] value in
                self?.viewModel.setBirthday(date: value)
                self?.viewModel.checkAge(date: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.birthday
            .asDriver(onErrorJustReturn: Date())
            .drive(onNext: { [weak self] value in
                //텍스트필드 바꾸기
                self?.setTextField(date: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.buttonStatus
            .asDriver(onErrorJustReturn: ButtonStatus.disable)
            .drive(onNext: { [unowned self] value in
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.setCheckStatus()
            })
            .disposed(by: disposeBag)
        
        viewModel.checkStatus
            .asDriver(onErrorJustReturn: .disable)
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
            //이메일로 전환
            let vc = EmailViewController()
            transition(vc, transitionStyle: .push)
        case .disable:
            presentToast(view: mainView, message: BirthdayStatus.disable.message)
        }
    }
}
