//
//  PhoneNumberViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit

final class PhoneNumberViewController: BaseViewController {
    
    var mainView = PhoneNumberView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
