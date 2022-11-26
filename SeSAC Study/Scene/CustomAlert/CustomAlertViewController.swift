//
//  CustomAlertViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/26.
//

import UIKit

final class CustomAlertViewController: ViewController {
    
    private var mainView = CustomAlertView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    func bind() {
        
    }
}
