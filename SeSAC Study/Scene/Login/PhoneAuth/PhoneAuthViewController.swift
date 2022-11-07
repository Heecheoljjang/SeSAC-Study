//
//  PhoneAuthViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit

final class PhoneAuthViewController: BaseViewController {
    
    var mainView = PhoneAuthView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        
//        navigationItem.hidesBackButton = true

    }
}
