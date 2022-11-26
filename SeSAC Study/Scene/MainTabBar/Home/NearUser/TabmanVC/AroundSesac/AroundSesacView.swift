//
//  AroundSesacView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/25.
//

import UIKit
import SnapKit

final class AroundSesacView: BaseView {
    
    let noSesacView = NoSesacView(bigLabelText: NoSesacViewLabel.noAround.bigLabelText, smallLabelText: NoSesacViewLabel.noAround.smallLabelText)
    
    let tableView: DynamicTableView = {
        let view = DynamicTableView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.separatorStyle = .none
        view.isScrollEnabled = false
        view.allowsMultipleSelection = true //MARK: test
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        view.sectionHeaderTopPadding = 0
        view.rowHeight = UITableView.automaticDimension
        view.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [noSesacView, tableView].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        noSesacView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.centerY.equalToSuperview()
            make.height.equalTo(160)
        }
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
