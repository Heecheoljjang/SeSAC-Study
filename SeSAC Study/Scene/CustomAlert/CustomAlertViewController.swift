//
//  CustomAlertViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/26.
//

import UIKit
import RxSwift
import RxCocoa

final class CustomAlertViewController: ViewController {
    
    var mainView = CustomAlertView()
    private let disposeBag = DisposeBag()
    
    weak var delegate: CustomAlertDelegate?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    func bind() {
        mainView.okButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //MARK: 디스미스때문에 뷰모델에서만 처리할 수가 업승ㅁ.
                self?.dismiss(animated: true, completion: {
                    self?.delegate?.ok()
                })
            })
            .disposed(by: disposeBag)
        mainView.cancelButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    self?.delegate?.cancel()
                })
            })
            .disposed(by: disposeBag)
    }
}

