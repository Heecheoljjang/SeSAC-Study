//
//  ShopSesacViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/04.
//

import UIKit

final class ShopSesacViewController: ViewController {
    
    private var mainView = ShopSesacView()
    private let viewModel = ShopSesacViewModel()
    
    weak var delegate: ShopSesacDelegate?
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configure() {
        super.configure()
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    func bind() {
        
    }
}

extension ShopSesacViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopSesacCollectionViewCell.identifier, for: indexPath) as? ShopSesacCollectionViewCell else { return UICollectionViewCell() }

        return cell
    }
}
