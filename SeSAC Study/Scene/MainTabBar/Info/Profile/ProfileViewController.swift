//
//  ProfileViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import RxCocoa
import RxSwift

final class ProfileViewController: ViewController {
    private var mainView = ProfileView()
    private let viewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    private let saveButton = UIBarButtonItem(title: ButtonTitle.save, style: .plain, target: nil, action: nil)
    
    private var isCollapsed = true
    
    private var test: [Int] = []
    
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        mainView.cardView.tableView.delegate = self
        mainView.cardView.tableView.dataSource = self
        
        
        
    }
    
    func bind() {
//        saveButton.rx.tap
//            .bind(onNext: { [weak self] _ in
//                self?.viewModel.saveInfo()
//            })
//            .disposed(by: T##DisposeBag)
    }
    
    override func configure() {
        super.configure()
        
        title = "정보 관리"
        
        let tapHeaderView = UITapGestureRecognizer(target: self, action: #selector(tapHeaderView))
        mainView.headerView.addGestureRecognizer(tapHeaderView)
    }
    
    @objc private func tapHeaderView() {
        print("123")
//        isCollapsed ? mainView.cardView.tableView.insertRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 0)], with: .fade) : mainView.cardView.tableView.deleteRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 0)], with: .fade)
        if isCollapsed {
            //true면 접혀있는 상태니까 펴야하므로 insert
            test.append(contentsOf: [1,2,3])
            mainView.cardView.tableView.insertRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 0)], with: .automatic)
        } else {
            //반대
            test.removeAll()
            mainView.cardView.tableView.deleteRows(at: [IndexPath(row: 2, section: 0), IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 0)], with: .automatic)
        }

        mainView.headerView.chevronButton.rotate(isCollapsed ? .pi : 0, duration: 0.3)
        isCollapsed = !isCollapsed
//        mainView.cardView.tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isCollapsed {
//            return 0
//        } else {
//            return 3
//        }
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sesacTitleCell = tableView.dequeueReusableCell(withIdentifier: SesacTitleTableViewCell.identifier) as? SesacTitleTableViewCell, let studyCell = tableView.dequeueReusableCell(withIdentifier: StudyTableViewCell.identifier) as? StudyTableViewCell, let reviewCell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier) as? ReviewTableViewCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            return sesacTitleCell
        case 1:
            return studyCell
        default:
            return reviewCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        mainView.headerView.nameLabel.text = "윤희철"
        return mainView.headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 170
        default:
            return UITableView.automaticDimension
        }
    }
}

