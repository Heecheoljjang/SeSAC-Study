//
//  NicknameViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import RxCocoa
import RxSwift

final class NicknameViewController: BaseViewController {
    
    private var mainView = NicknameView(message: LoginText.nickName.message, detailMessage: LoginText.nickName.detailMessage, buttonTitle: ButtonTitle.next)
    private let viewModel = NickNameViewModel()
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
            mainView.nicknameTextField.text = viewModel.fetchNickname()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.checkInvalid() {
            presentToast(view: mainView, message: NicknameCheck.fail.message)
        }
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.setInvalid()
    }
    
    private func bind() {
        
        mainView.nicknameTextField.rx.text
            .orEmpty
            .map{ $0.count >= 1 && $0.count <= 10 }
            .bind(onNext: { [weak self] value in
                value ? self?.viewModel.setButtonStatus(value: ButtonStatus.enable) : self?.viewModel.setButtonStatus(value: ButtonStatus.disable)
            })
            .disposed(by: disposeBag)
        
        mainView.nicknameTextField.rx.text
            .orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .map { $0.count > 10 }
            .bind(onNext: { [unowned self] value in
                if value {
                    self.textFieldRemoveLast(textField: self.mainView.nicknameTextField)
                    self.dismissKeyboard()
                }
            })
            .disposed(by: disposeBag)
        
//        mainView.nicknameTextField.rx.text
//            .orEmpty
//            .bind(onNext: { [weak self] value in
//                self?.viewModel.setNickname(name: value)
//            })
//            .disposed(by: disposeBag)
        
        viewModel.buttonStatus
            .asDriver(onErrorJustReturn: ButtonStatus.disable)
            .drive(onNext: { [unowned self] value in
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.checkIsEnable()
            })
            .disposed(by: disposeBag)
            
        viewModel.isEnable
            .asDriver(onErrorJustReturn: .fail)
            .drive(onNext: { [weak self] value in
                self?.nicknameCheck(isEnable: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentKeyboard() {
        mainView.nicknameTextField.becomeFirstResponder()
    }
    
    private func dismissKeyboard() {
        mainView.nicknameTextField.resignFirstResponder()
    }
    
    private func nicknameCheck(isEnable: NicknameCheck) {
        switch isEnable {
        case .lengthFail, .fail:
            presentToast(view: mainView, message: isEnable.message)
        case .success:
            presentToast(view: mainView, message: isEnable.message)

            viewModel.setNickname(name: mainView.nicknameTextField.text ?? "")
            
            //MARK: 화면 전환
            let vc = BirthdayViewController()
            print("닉네임: \(UserDefaultsManager.shared.fetchValue(type: .nick) as? String)")
            transition(vc, transitionStyle: .push)
        }
    }
    
    //MARK: - 수정하기 뷰모델에서 처리하거나 String의 Extension으로
    private func textFieldRemoveLast(textField: UITextField) {
        textField.text?.removeLast()
    }
}
