//
//  LaunchViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import Foundation

final class LaunchViewModel {
    
    func checkIsFirst() -> Bool {
        guard let isFirst = UserDefaultsManager.shared.fetchValue(type: .isFirst) as? Int else { return false }
        
        return isFirst == 0 ? true : false
    }
    
}
