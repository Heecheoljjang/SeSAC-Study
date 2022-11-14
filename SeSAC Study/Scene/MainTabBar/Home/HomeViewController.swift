//
//  dfs.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit

final class HomeViewController: BaseViewController {
    private var mainView = HomeView()
    private let viewModel = HomeViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - 유저디폴트 지워주기
        viewModel.removeUserDefatuls()
    }
}
