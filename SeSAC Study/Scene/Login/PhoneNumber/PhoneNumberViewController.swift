//
//  PhoneNumberViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift

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
            .bind(to: mainView.doneButton.rx.isEnabled)
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
    }
 }
