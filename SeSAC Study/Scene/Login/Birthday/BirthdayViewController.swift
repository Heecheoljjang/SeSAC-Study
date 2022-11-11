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
        print(#function)
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentKeyboard()
        print("유저: \(UserDefaultsManager.shared.fetchValue(type: .birth) as? String)")
        //유저디폴트 확인해서 값이 nil이 아니라면 setBirth하기.
        if viewModel.checkUserDefaultsExist() {
            print(viewModel.checkUserDefaultsExist())
            //nil이 아니라는 거니까 birthday accept해주기, datepicker날짜 바꾸기
            print("실행됨")
            let birth = viewModel.fetchBirth()
            viewModel.setBirthday(date: birth)
            mainView.datePicker.date = birth
            print("피커 데이트 변경됨 \(birth)")
        }
    }
    
    private func bind() {
        
        mainView.datePicker.rx.date
            .bind(onNext: { [weak self] value in
                print("데이트피커 \(value)")
                self?.viewModel.setBirthday(date: value)
//                self?.viewModel.checkAge(date: value) => birthday로 옮김
            })
            .disposed(by: disposeBag)
        
        viewModel.birthday
//            .asSignal(onErrorJustReturn: Date())
            .asDriver(onErrorJustReturn: Date())
            .drive(onNext: { [weak self] value in
                print("버스데이: \(value)")
                //텍스트필드 바꾸기, 데이트피커 날짜도
                self?.setTextField(date: value)

                self?.viewModel.setBirth(date: value)

                self?.viewModel.checkAge(date: value)
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
