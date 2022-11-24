//
//  NearUserVIew.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/24.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

final class NearUserView: BaseView {
        
    let button: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .brandGreen
        configuration.baseForegroundColor = .white
        configuration.title = ButtonTitle.changeStudy
        button.configuration = configuration
        return button
    }()
    
    let retryButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .brandGreen
        configuration.image = UIImage(named: ImageName.retry)
        button.layer.borderColor = UIColor.brandGreen.cgColor
        button.layer.borderWidth = 1
        button.configuration = configuration
        return button
    }()
    
    let barItem = [TMBarItem(title: NearUserVC.around.title), TMBarItem(title: NearUserVC.received.title)]
    
    let buttonBar: TMBar.ButtonBar = {
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.contentMode = .fit
        bar.buttons.customize { button in
            button.tintColor = .graySix
            button.selectedTintColor = .brandGreen
        }
        bar.indicator.tintColor = .brandGreen
        bar.indicator.weight = .light
        bar.systemBar().backgroundStyle = .clear
        return bar
    }()
    
    let stopButton = UIBarButtonItem(title: ButtonTitle.stop, style: .plain, target: nil, action: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        super.configure()
        [button, retryButton].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        retryButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.size.equalTo(48)
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalTo(retryButton.snp.leading).offset(-8)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
        }
    }
}
