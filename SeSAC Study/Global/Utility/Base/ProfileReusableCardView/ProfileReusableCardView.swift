//
//  ProfileReusableCell.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import SnapKit

class ProfileReusableCardView: BaseView {
    
    let tableView: DynamicTableView = {
        let view = DynamicTableView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        view.sectionHeaderTopPadding = 0
        view.rowHeight = UITableView.automaticDimension
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        addSubview(tableView)
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
