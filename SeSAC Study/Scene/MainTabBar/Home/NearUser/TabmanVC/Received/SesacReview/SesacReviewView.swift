//
//  SesacReviewView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/27.
//

import UIKit
import SnapKit

final class SesacReviewView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.register(SesacReviewTableViewCell.self, forCellReuseIdentifier: SesacReviewTableViewCell.identifier)
        view.allowsSelection = false
        view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
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
            make.verticalEdges.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
