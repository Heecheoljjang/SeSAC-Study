//
//  ShopBackgroundView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/05.
//

import UIKit
import SnapKit

final class ShopBackgroundView: BaseView {
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayTwo
        return view
    }()
    
    let tableView: DynamicTableView = {
        let view = DynamicTableView(frame: CGRect.zero, style: .plain)
        view.register(ShopBackgroundTableViewCell.self, forCellReuseIdentifier: ShopBackgroundTableViewCell.identifier)
        view.rowHeight = UITableView.automaticDimension
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [lineView, tableView].forEach {
            addSubview($0)
        }
        backgroundColor = .blue
    }
    override func setUpConstraints() {
        super.setUpConstraints()
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}
