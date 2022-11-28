//
//  ChattingView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/26.
//

import UIKit
import SnapKit

final class ChattingView: BaseView {
    
    lazy var headerView = ChattingHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 112))
    
    let backButton = UIBarButtonItem(image: UIImage(named: ImageName.leftArrow), style: .plain, target: nil, action: nil)
    let menuBarButton = UIBarButtonItem(image: UIImage(systemName: ImageName.ellipsis), style: .plain, target: nil, action: nil)

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(MyChattingTableViewCell.self, forCellReuseIdentifier: MyChattingTableViewCell.identifier)
        view.register(YourChattingTableViewCell.self, forCellReuseIdentifier: YourChattingTableViewCell.identifier)
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.tableHeaderView = headerView
        return view
    }()
    
    let messageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .grayOne
        return view
    }()
    let textView: VerticallyCenteredTextView = {
        let view = VerticallyCenteredTextView()
        view.textColor = .graySeven
        view.font = UIFont(name: CustomFont.regular, size: 14)
//        view.textContainer.maximumNumberOfLines = 3
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.text = PlaceHolder.chatting
        view.textColor = .graySeven
        view.backgroundColor = .grayOne
        view.isScrollEnabled = false
        return view
    }()
    let sendButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(named: ImageName.sendButton)
        configuration.baseForegroundColor = .graySix
//        configuration.preferredSymbolConfigurationForImage = UIImage.
        button.configuration = configuration
//        button.clipsToBounds = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [textView, sendButton].forEach {
            messageView.addSubview($0)
        }
        [tableView, messageView].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(messageView.snp.top).offset(-12)
            make.top.equalTo(self.safeAreaLayoutGuide)
        }
        sendButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalTo(messageView).offset(-14)
            make.centerY.equalTo(messageView)
        }
        textView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(messageView).inset(14)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
        }
        messageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.greaterThanOrEqualTo(52)
        }
    }
}
