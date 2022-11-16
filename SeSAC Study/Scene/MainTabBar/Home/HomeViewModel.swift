//
//  MainViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/13.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    
    func removeUserDefatuls() {
        UserDefaultsManager.shared.removeSomeValue()
    }
}
