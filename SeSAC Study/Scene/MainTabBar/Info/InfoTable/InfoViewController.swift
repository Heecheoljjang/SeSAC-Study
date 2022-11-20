//
//  InfoViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import RxCocoa
import RxSwift

final class InfoViewController: ViewController {
    private var mainView = InfoView()
    private let disposeBag = DisposeBag()
    private let viewModel = InfoViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("123")
        bind()
        viewModel.setNickName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("뷰윌어피어")
        viewModel.setNickName()
    }
    
    func bind() {
            
        viewModel.nickName
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [unowned self] value in
                self.mainView.nameLabel.text = value
            })
            .disposed(by: disposeBag)
        
        mainView.clearButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //화면전환
                print("호마ㅕㄴ전환")
            })
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        super.configure()
        
        title = TabBarData.info.title
    }
}
