//
//  GenderViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/10.
//

import UIKit
import RxGesture
import RxSwift
import RxCocoa

final class GenderViewController: ViewController {
    
    private var mainView = GenderView(message: LoginText.gender.message, detailMessage: LoginText.gender.detailMessage, buttonTitle: ButtonTitle.next)
    private let disposeBag = DisposeBag()
    private let viewModel = GenderViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkUserDefaultsExist()
    }
    
    func bind() {
        let input = GenderViewModel.Input(tapDoneButton: mainView.doneButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        mainView.manView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                self?.viewModel.setGenderMan()
                self?.viewModel.setButtonEnable()
            })
            .disposed(by: disposeBag)
        
        mainView.womanView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                self?.viewModel.setGenderWoman()
                self?.viewModel.setButtonEnable()
            })
            .disposed(by: disposeBag)
        
        output.gender
            .drive(onNext: { [weak self] value in
                self?.changeViewColor(gender: value)
                self?.viewModel.setGender(gender: value)
                self?.viewModel.setButtonEnable()
            })
            .disposed(by: disposeBag)
        
        output.buttonStatus
            .drive(onNext: { [unowned self] value in
                self.changeNextButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)
        
        output.tapDoneButton
        
        output.genderStatus
            .drive(onNext: { [weak self] value in
                self?.statusCheck(status: value)
            })
            .disposed(by: disposeBag)
        
        output.errorStatus
            .drive(onNext: { [weak self] value in
                self?.checkErrorStatus(status: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func changeViewColor(gender: Gender) {
        switch gender {
        case .man:
            mainView.manView.backgroundColor = .brandWhiteGreen
            mainView.manView.layer.borderColor = UIColor.brandWhiteGreen.cgColor
            mainView.womanView.backgroundColor = .white
            mainView.womanView.layer.borderColor = UIColor.grayThree.cgColor
        case .woman:
            mainView.womanView.backgroundColor = .brandWhiteGreen
            mainView.womanView.layer.borderColor = UIColor.brandWhiteGreen.cgColor
            mainView.manView.backgroundColor = .white
            mainView.manView.layer.borderColor = UIColor.grayThree.cgColor
        }
    }
    
    private func statusCheck(status: GenderStatus) {
        switch status {
        case .selected:
            LoadingIndicator.showLoading()
            viewModel.requestSignUp()
        case .unselected:
            presentToast(view: mainView, message: status.message)
        }
    }
    private func checkErrorStatus(status: LoginError) {
        switch status {
        case .signUpSuccess:
            viewModel.setInvalidNickname(value: false)
            let main = MainTabBarController()
            changeRootViewController(viewcontroller: main, isTabBar: true)
        case .alreadyExistUser:
            LoadingIndicator.hideLoading()
            presentToast(view: mainView, message: LoginError.alreadyExistUser.message)
        case .invalidNickname:
            LoadingIndicator.hideLoading()
            viewModel.setInvalidNickname(value: true)
            if let viewController = navigationController?.viewControllers.first(where: {$0 is NicknameViewController}) {
                  navigationController?.popToViewController(viewController, animated: false)
            }
        case .tokenError:
            print("토큰 에러")
            viewModel.fetchIdToken()
        case .signUpRequired:
            print("나올 일 없음")
            LoadingIndicator.hideLoading()
        case .serverError:
            print("서버 에러")
            LoadingIndicator.hideLoading()
        case .clientError:
            print("클라이언트 에러. 헤더랑 바디 확인")
            LoadingIndicator.hideLoading()
        }
    }
}
