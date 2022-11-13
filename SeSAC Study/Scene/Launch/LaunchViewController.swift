//
//  LaunchViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import UIKit
import RxSwift
import RxCocoa

/*
 여기서 화면 분기처리
 유저디폴트 확인해서 온보딩으로 보낼건지, 핸드폰번호 화면으로 보낼건지
 바꿀때 루트뷰를 바꿔주기
 
 
 - 유저디폴트에 핸드폰 번호와 아이디 토큰이 있는거면 파베까지하고 나간사람임 -> 닉네임 화면으로 => onlyfirebase
 - 유저디폴트에 아이디 토큰만 있으면 회원가입이 완료된 사용자 -> 그냥 처음부터 => registered
 - isFirst가 0이라면 온보딩으로 => 온보딩화면이면 유저디폴트 전부 삭제(회원탈퇴) => onboarding
 
 => 프로퍼티 하나 두고 유저디폴트 체크해서 상태 accept해주고 화면전환 메서드 실행
 
 */

final class LaunchViewController: BaseViewController {
    
    private var mainView = LaunchView()
    private let viewModel = LaunchViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //여기서 유저디폴트로 값 넣어주는 메서드 실행
        viewModel.checkUserStatus()
    }
    
    private func bind() {
        viewModel.status
            .asDriver(onErrorJustReturn: .onboarding)
            .drive(onNext: { [weak self] value in
                self?.changeVC(status: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func changeVC(status: UserStatus) {
        switch status {
        case .onboarding:
            let vc = OnboardingViewController()
            changeRootViewController(viewcontroller: vc)
        case .registered:
            let vc = PhoneNumberViewController()
            changeRootViewController(viewcontroller: vc)
        case .onlyFirebase:
            let vc = NicknameViewController()
            changeRootViewController(viewcontroller: vc)
        }
    }
}
