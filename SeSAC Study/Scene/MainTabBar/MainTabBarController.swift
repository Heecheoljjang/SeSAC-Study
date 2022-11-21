//
//  MainTabBarController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let homeVC = MainViewController()
    private let shopVC = ShopViewController()
    private let friendVC = FriendViewController()
    private let infoVC = InfoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setUpAppearance()
        
    }
    
    private func configure() {
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem.image = UIImage(named: TabBarData.home.baseIcon)
        homeNav.tabBarItem.selectedImage = UIImage(named: TabBarData.home.selectedIcon)
        homeNav.tabBarItem.title = TabBarData.home.title
        
        let shopNav = UINavigationController(rootViewController: shopVC)
        shopNav.tabBarItem.image = UIImage(named: TabBarData.shop.baseIcon)
        shopNav.tabBarItem.selectedImage = UIImage(named: TabBarData.shop.selectedIcon)
        shopNav.tabBarItem.title = TabBarData.shop.title
        
        let friendNav = UINavigationController(rootViewController: friendVC)
        friendNav.tabBarItem.image = UIImage(named: TabBarData.friend.baseIcon)
        friendNav.tabBarItem.selectedImage = UIImage(named: TabBarData.friend.selectedIcon)
        friendNav.tabBarItem.title = TabBarData.friend.title
        
        let infoNav = UINavigationController(rootViewController: infoVC)
        infoNav.tabBarItem.image = UIImage(named: TabBarData.info.baseIcon)
        infoNav.tabBarItem.selectedImage = UIImage(named: TabBarData.info.selectedIcon)
        infoNav.tabBarItem.title = TabBarData.info.title
        
        setViewControllers([homeNav, shopNav, friendNav, infoNav], animated: true)
    }
    
    private func setUpAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .brandGreen
    }
}
