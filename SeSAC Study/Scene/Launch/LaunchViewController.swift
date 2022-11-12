//
//  LaunchViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import UIKit

/*
 여기서 화면 분기처리
 유저디폴트 확인해서 온보딩으로 보낼건지, 핸드폰번호 화면으로 보낼건지
 바꿀때 루트뷰를 바꿔주기
 */

final class LaunchViewController: BaseViewController {
    
    private var mainView = LaunchView()
    private let viewModel = LaunchViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel.checkIsFirst() {
            //온보딩
            print("ㅇㄹ")
            let vc = OnboardingViewController()
            changeRootViewController(viewcontroller: vc)
        } else {
            //전화번호
            print("이라머")
            let vc = PhoneNumberViewController()
            changeRootViewController(viewcontroller: vc)
        }
    }
    
    deinit {
        print("런치 디이닛")
    }
}
