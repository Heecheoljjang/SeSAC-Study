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

final class NearUserViewController: TabmanViewController {
    
    private var mainView = NearUserView()
    private let viewModel = NearUserViewModel()
    private let disposeBag = DisposeBag()
    
    private let viewControllers = [AroundSesacViewController(), ReceivedViewController()]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func configure() {
        dataSource = self
        title = NavigationBarTitle.sesacSearch.title
        navigationItem.rightBarButtonItem = mainView.stopButton
        addBar(mainView.buttonBar, dataSource: self, at: .top)
    }
    
    func bind() {
        mainView.stopButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //찾기중단 네트워크통신
                self?.viewModel.stopSesacSearch()
            })
            .disposed(by: disposeBag)
        viewModel.cancelStatus
            .asDriver(onErrorJustReturn: .clientError)
            .drive(onNext: { [weak self] value in
                self?.checkCancelStatus(status: value)
            })
            .disposed(by: disposeBag)
        mainView.changeStudyButton.rx.tap
            .withUnretained(self)
            .bind(onNext: { (vc, _) in
                //이전화면으로
                vc.transition(vc, transitionStyle: .pop)
            })
            .disposed(by: disposeBag)
    }
}

extension NearUserViewController {
    private func checkCancelStatus(status: SesacCancelError) {
        switch status {
        case .cancelSuccess:
            //홈 화면(이전화면)으로 이동
            transition(self, transitionStyle: .pop)
        case .alreadyCancel:
            presentToast(view: mainView, message: status.message)
            //MARK: 채팅화면으로 이동
        default:
            presentToast(view: mainView, message: status.message)
        }
    }
}

extension NearUserViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return mainView.barItem[index]
    }
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
