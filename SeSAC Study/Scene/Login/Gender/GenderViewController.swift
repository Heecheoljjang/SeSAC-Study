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
    
    private func bind() {
        mainView.manView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                //MARK: gender값 변경
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
                self?.changeViewColor(gender: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.buttonStatus
            .asDriver(onErrorJustReturn: .disable)
            .drive(onNext: { [unowned self] value in
                self.changeButtonColor(button: self.mainView.doneButton, status: value)
            })
            .disposed(by: disposeBag)
        
        mainView.doneButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.checkStatus()
            })
            .disposed(by: disposeBag)
        
        viewModel.genderStatus
            .asDriver(onErrorJustReturn: .unselected)
            .drive(onNext: { [weak self] value in
                self?.statusCheck(status: value)
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
            //MARK: 회원가입 네트워킹
            print("네트워킹")
        case .unselected:
            presentToast(view: mainView, message: status.message)
        }
    }
}
