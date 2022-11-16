//
//  ReusableButton.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//
import UIKit

class ReusableButton: UIButton {

    var title = ""
    
    init(title: String) {
        self.title = title
        super.init(frame: CGRect.zero)
            
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseForegroundColor = .black
        configuration.baseBackgroundColor = .white
        configuration.cornerStyle = .medium
        
        self.configuration = configuration
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.graySix.cgColor
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.isUserInteractionEnabled = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
