//
//  ShopTabmanViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/05.
//

import UIKit
import Tabman
import Pageboy

final class ShopTabmanViewController: TabmanViewController {
    
    private var mainView = ShopTabmanView()
    private let viewControllers = [ShopSesacViewController(), ShopBackgroundViewController()]
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        dataSource = self
        addBar(mainView.buttonBar, dataSource: self, at: .top)
    }
}

extension ShopTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {
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
