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
 
 id토큰이 없다 => 온보딩
 id토큰이 있다 => 서버통신 => 406이다 => 닉네임
                      => 200이다 => 홈화면
 */

final class LaunchViewController: ViewController {
    
    private var mainView = LaunchView()
    private let viewModel = LaunchViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
//        viewModel.setLocationAuth() //위치권한 기본값 0으로 저장
        viewModel.checkIdToken()
    }

    func bind() {
        let input = LaunchViewModel.Input()
        let output = viewModel.transform(input: input)
    
        output.idTokenIsEmpty
            .drive(onNext: { [weak self] value in
                //true면 비어있음
                self?.setStatus(status: value)
            })
            .disposed(by: disposeBag)
        
        output.status
            .drive(onNext: { [weak self] status in
                self?.changeVC(status: status)
            })
            .disposed(by: disposeBag)
    }
    
    private func setStatus(status: Bool) {
        switch status {
        case true:
            viewModel.setStatus(status: .clientError) //온보딩으로 가게
        case false:
            //서버통신 후에 상태에 따라서
            viewModel.checkUserStatus()
        }
    }
    private func changeVC(status: LoginError) {
        print("status====\(status)")
        switch status {
        case .signUpRequired:
            //406이 뜬거니까 닉네임으로
            let vc = NicknameViewController()
            changeRootViewController(viewcontroller: vc, isTabBar: false)
        case .signUpSuccess:
            //성공이니까 홈으로
            let vc = MainTabBarController()
            changeRootViewController(viewcontroller: vc, isTabBar: true)
        default:
            let vc = OnboardingViewController()
            changeRootViewController(viewcontroller: vc, isTabBar: false)
        }
    }
}
