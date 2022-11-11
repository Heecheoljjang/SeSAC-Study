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
        
        bind()
    }
    
    override func configure() {
        super.configure()
        //MARK: 백버튼 바꾸기
        navigationItem.backButtonTitle = ""
//        let backButton = UIBarButtonItem(image: UIImage(systemName: ImageName.leftArrow), style: .done, target: nil, action: nil)
//        navigationItem.backBarButtonItem = backButton
////        self.navigationBar.backIndicatorTransitionMaskImage
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: ImageName.leftArrow)
    }
    
    private func bind() {
        mainView.numberTextField.rx.text
            .orEmpty
            .bind(onNext: { [weak self] value in
                self?.viewModel.setPhoneNumber(number: value) //전화번호
                self?.viewModel.checkPhoneNumber(number: value) //유효한지 체크
            })
            .disposed(by: disposeBag)
        
        viewModel.phoneNumber
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] value in
                self?.mainView.numberTextField.text = value.pretty()
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
                self?.viewModel.sendPhoneAuth()
            })
            .disposed(by: disposeBag)
        
        viewModel.sendAuthCheck
            .asDriver(onErrorJustReturn: .fail)
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
            let vc = PhoneAuthViewController()
            transition(vc, transitionStyle: .push)
        }
    }
 }
