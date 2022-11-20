//
//  MyInfoReusableView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/20.
//

import UIKit
import SnapKit

class MyInfoReusableView: BaseView {

    var type: MyInfoReusableType
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: type.imageName)
        
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = type.labelText
        label.font = UIFont(name: CustomFont.regular, size: 16)
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayTwo
        
        return view
    }()
    
    init(type: MyInfoReusableType) {
        self.type = type
        super.init(frame: CGRect.zero)
    }
    
    override func configure() {
        super.configure()
        [imageView, label, lineView].forEach {
            addSubview($0)
        }
        backgroundColor = .brandGreen
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        lineView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
    }
}
