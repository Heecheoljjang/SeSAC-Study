//
//  MainView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/13.
//

import UIKit
import SnapKit
import MapKit

final class MainView: BaseView {
    
    let mapView: MKMapView = {
        let view = MKMapView()
        view.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: 100, maxCenterCoordinateDistance: 6000), animated: true)
        
        return view
    }()
    
    let findButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.image = UIImage(named: ImageName.searchDefault)
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.layer.cornerRadius = 8
        view.backgroundColor = .red
        view.clipsToBounds = true
        
        return view
    }()
    
    let totalButton: UIButton = {
        let button = UIButton()
        button.setTitle(ButtonTitle.total, for: .normal)
        button.backgroundColor = .brandGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFont.regular, size: 14)
        return button
    }()
    let manButton: UIButton = {
        let button = UIButton()
        button.setTitle(ButtonTitle.man, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFont.regular, size: 14)
        return button
    }()
    let womanButton: UIButton = {
        let button = UIButton()
        button.setTitle(ButtonTitle.woman, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFont.regular, size: 14)
        return button
    }()
    
    let myLocationButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: ImageName.gps)
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .white
        
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.configuration = configuration
        return button
    }()
    
    let centerAnnotation: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ImageName.centerAnnotation)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .brandGreen
    }
    
    override func configure() {
        super.configure()
        [totalButton, manButton, womanButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        [mapView, buttonStackView, myLocationButton, findButton, centerAnnotation].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        mapView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(52)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(48)
            make.height.equalTo(144)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(16)
            make.size.equalTo(48)
            make.leading.equalTo(buttonStackView)
        }
        
        findButton.snp.makeConstraints { make in
            make.size.equalTo(64)
            make.trailing.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
        }
        
        centerAnnotation.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(48)
        }
    }
    
}
