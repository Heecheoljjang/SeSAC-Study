//
//  ShopViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import Tabman
import Pageboy

final class ShopViewController: ViewController, ShopDelegate {

    private var mainView = ShopView()
    
    private let tabmanVC = ShopTabmanViewController()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func configure() {
        super.configure()
        title = NavigationBarTitle.shop.title
        
        tabmanVC.view.frame = mainView.containerView.bounds
        addChild(tabmanVC)
        mainView.containerView.addSubview(tabmanVC.view)
        tabmanVC.didMove(toParent: self)
    }
    
    func bind() {
        
    }
    
}

extension ShopViewController{
    func changeSesacImage() {
        print("1")
    }
    
    func changeBackgroundImage() {
        print("2")
    }
}
