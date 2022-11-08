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
    
    private var mainView = PhoneNumberView()
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
        //MARK: - 다시 디테일하게 해야함
        //일단 앞이 01이고 10자리가 넘으면 버튼활성화
        mainView.numberTextField.rx.text
            .orEmpty
            .map{ $0.count >= 10 && $0[0] == "0" && $0[1] == "1"}
//            .bind(to: mainView.doneButton.rx.isEnabled)
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
        
        mainView.numberTextField.rx.text
            .orEmpty
            .bind(onNext: { [weak self] value in
                print("value: \(value)")
                self?.viewModel.setPhoneNumber(number: value)
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
                //sendAuthCheck상태에 따라서 토스트 띄우거나 다음 화면으로 넘어감
                print(value)
                self?.authCheck(value: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func authCheck(value: AuthCheck) {
        switch value {
        case .wrongNumber:
            presentToast(view: mainView, message: AuthCheck.wrongNumber.message)
        case .fail:
            presentToast(view: mainView, message: AuthCheck.fail.message)
        case .manyRequest:
            presentToast(view: mainView, message: AuthCheck.manyRequest.message)
        case .success:
            presentToast(view: mainView, message: AuthCheck.success.message)
            let vc = PhoneAuthViewController()
            transition(vc, transitionStyle: .push)
        }
    }
 }
