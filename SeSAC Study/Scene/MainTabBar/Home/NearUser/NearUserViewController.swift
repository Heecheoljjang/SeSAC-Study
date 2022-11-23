//
//  NearUserViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/18.
//

import UIKit
import Tabman
import Pageboy
import RxSwift
import RxCocoa

final class NearUserViewController: ViewController {
    
//    private var mainView = NearUserView()
//    private let viewModel = NearUserViewModel()
    private let disposeBag = DisposeBag()
    private let stopButton = UIBarButtonItem(title: ButtonTitle.stop, style: .plain, target: nil, action: nil)
    private let aroundSesacVC = AroundSesacViewController()
    private let ReceivedVC = ReceivedViewController()
//    private let viewControllers = [aroun]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        
        navigationItem.rightBarButtonItem = stopButton
    }
    
    func bind() {
        stopButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //찾기중단 네트워크통신
            })
            .disposed(by: disposeBag)
    }
}
