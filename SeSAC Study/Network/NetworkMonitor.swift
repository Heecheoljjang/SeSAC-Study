//
//  NetworkCheck.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import UIKit
import Network
import SnapKit

final class NetworkMonitor {
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                statusUpdateHandler(path.status)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}

final class NetWorkErrorView: BaseView {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "네트워크 연결을 확인해주세요."
        label.font = UIFont(name: CustomFont.medium, size: 20)
        label.backgroundColor = .graySix
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        addSubview(label)
        backgroundColor = .clear
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(200)
        }
    }
}
