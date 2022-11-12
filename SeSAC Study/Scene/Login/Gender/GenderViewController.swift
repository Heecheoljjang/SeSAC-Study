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

final class GenderViewController: BaseViewController {
    
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
    
    private func bind() {
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
        
        viewModel.gender
            .asDriver(onErrorJustReturn: .man)
            .drive(onNext: { [weak self] value in
                print("젠더가 바뀌었다")
                self?.changeViewColor(gender: value)
                self?.viewModel.setGender(gender: value)
                self?.viewModel.setButtonEnable()
            })
            .disposed(by: disposeBag)
        
        viewModel.buttonStatus
            .asDriver(onErrorJustReturn: .disable)
            .drive(onNext: { [unowned self] value in
                print("버튼상태바뀌었ㄷ")
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind(onNext: { [weak self] _ in
                print("탭 됨")
                self?.viewModel.checkStatus()
            })
            .disposed(by: disposeBag)
        
        viewModel.genderStatus
            .asDriver(onErrorJustReturn: .unselected)
            .drive(onNext: { [weak self] value in
                print("젠더상태바뀜")
                self?.statusCheck(status: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] value in
                print("에러상태바뀜")
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
            viewModel.requestSignUp()
        case .unselected:
            presentToast(view: mainView, message: status.message)
        }
    }
    
    private func checkErrorStatus(status: NetworkErrorString) {
        switch status {
        case .signUpSuccess:
            print("회원가입 성공")
            viewModel.setInvalidNickname(value: false)
            let vc = MainViewController()
            changeRootViewController(viewcontroller: vc)
        case .alreadyExistUser:
            print("이미 가입한 유저")
        case .invalidNickname:
            print("사용할 수 없는 닉네임")
            viewModel.setInvalidNickname(value: true)
            if let viewController = navigationController?.viewControllers.first(where: {$0 is NicknameViewController}) {
                  navigationController?.popToViewController(viewController, animated: false)
            }
        case .tokenError:
            print("토큰 에러")
            viewModel.fetchIdToken()
        case .signUpRequired:
            print("나올 일 없음")
        case .serverError:
            print("서버 에러")
        case .clientError:
            print("클라이언트 에러. 헤더랑 바디 확인")
        }
    }
}
