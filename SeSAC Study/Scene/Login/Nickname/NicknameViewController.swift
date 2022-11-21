//
//  NicknameViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import RxCocoa
import RxSwift

final class NicknameViewController: ViewController {
    
    private var mainView = NicknameView(message: LoginText.nickName.message, detailMessage: LoginText.nickName.detailMessage, buttonTitle: ButtonTitle.next)
    private let viewModel = NickNameViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //닉네임이 처음 로드될때는 첫 회원가입이니 유저디폴트 다 지우기
        viewModel.removeAllUserDefaults()
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
    
    func bind() {
        let input = NickNameViewModel.Input(nickNameText: mainView.nicknameTextField.rx.text, tapDoneButton: mainView.doneButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.validNicknameCount
            .bind(onNext: { [weak self] value in
                value ? self?.viewModel.setButtonStatus(value: ButtonStatus.enable) : self?.viewModel.setButtonStatus(value: ButtonStatus.disable)
            })
            .disposed(by: disposeBag)
        
        output.longNickname
            .bind(onNext: { [unowned self] value in
                if value {
                    self.textFieldRemoveLast(textField: self.mainView.nicknameTextField)
                    self.dismissKeyboard()
                }
            })
            .disposed(by: disposeBag)
        
        output.buttonStatus
            .drive(onNext: { [unowned self] value in
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)
        
        output.tapDoneButton
            .bind(onNext: { [weak self] _ in
                self?.viewModel.checkIsEnable()
            })
            .disposed(by: disposeBag)
            
        output.enableNickname
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
            
            let vc = BirthdayViewController()
            print("닉네임: \(UserDefaultsManager.shared.fetchValue(type: .nick) as? String)")
            transition(vc, transitionStyle: .push)
        }
    }
    
    private func textFieldRemoveLast(textField: UITextField) {
        textField.text?.removeLast()
    }
}
