//
//  ShopBackgroundViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/04.
//

import UIKit

final class ShopBackgroundViewController: ViewController {
    
    private var mainView = ShopBackgroundView()
    
    weak var delegate: ShopBackgroundDelegate?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configure() {
        super.configure()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func bind() {
        
    }
}

extension ShopBackgroundViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShopBackgroundTableViewCell.identifier) as? ShopBackgroundTableViewCell else { return UITableViewCell() }

        return cell
    }
}
