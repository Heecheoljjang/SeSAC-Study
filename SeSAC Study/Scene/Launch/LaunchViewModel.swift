//
//  LaunchViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import Foundation
import RxCocoa
import RxSwift

final class LaunchViewModel {
    
    var status = PublishRelay<UserStatus>()
    
    func checkIsFirst() -> Bool {
        guard let isFirst = UserDefaultsManager.shared.fetchValue(type: .isFirst) as? Int else { return false }
        
        return isFirst == 0 ? true : false
    }
    
    func checkUserStatus() {
        status.accept(UserDefaultsManager.shared.checkUserDefatuls())
    }
}
