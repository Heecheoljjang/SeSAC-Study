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
        bind()
        viewModel.fetchUserInfo()
    }

    func bind() {
            
        viewModel.userInfo
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [unowned self] value in
                guard let info = value else { return }
                guard let image = UserProfileImage(rawValue: info.sesac)?.image else { return }
                print("하하하하핳 \(info)")
                self.mainView.nameLabel.text = info.nick
                self.mainView.profileImage.image = UIImage(named: image)
            })
            .disposed(by: disposeBag)
        
        mainView.clearButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.checkUser()
            })
            .disposed(by: disposeBag)
        
        viewModel.currentStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] value in
                self?.transitionVC(status: value)
            })
            .disposed(by: disposeBag)
        print("바인드 마지막")
    }
    
    override func configure() {
        super.configure()
        
        title = TabBarData.info.title
    }
}

extension InfoViewController {
    private func transitionVC(status: LoginError) {
        //MARK: 통신한번해서 성공하면 넘어가야할듯
        switch status {
        case .signUpSuccess:
            //데이터 전달은 유저디폴트에 저장했으므로 화면전환만
            let vc = ProfileViewController()
            transition(vc, transitionStyle: .push)
        default:
            presentToast(view: mainView, message: ErrorText.message)
        }
    }
}
