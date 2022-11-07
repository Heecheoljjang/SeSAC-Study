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
        
        mainView.doneButton.rx.tap
            .bind(onNext: { _ in
                self.navigationController?.pushViewController(PhoneAuthViewController(), animated: true)
            })
            .disposed(by: disposeBag)
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
//            .map{ $0.method } //번호 이쁘게 만들어주는 메서드 만들어서 매핑으로 스트링타입으로 변형

            
    }
 }
