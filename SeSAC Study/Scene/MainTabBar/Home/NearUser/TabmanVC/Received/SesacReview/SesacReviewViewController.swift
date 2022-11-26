//
//  SesacReviewViewController.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/27.
//

import UIKit

final class SesacReviewViewController: ViewController {
    
    private var mainView = SesacReviewView()
    private let viewModel = SesacReviewViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind() {
        
    }
}
