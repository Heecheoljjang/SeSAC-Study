//
//  LaunchViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import Foundation
import RxCocoa
import RxSwift

final class LaunchViewModel: CommonViewModel {
    
    struct Input {}
    struct Output {
        let status: Driver<UserStatus>
    }
    func transform(input: Input) -> Output {
        let status = status.asDriver(onErrorJustReturn: .onboarding)
        
        return Output(status: status)
    }
    
    var status = PublishRelay<UserStatus>()
    
    func checkIsFirst() -> Bool {
        guard let isFirst = UserDefaultsManager.shared.fetchValue(type: .isFirst) as? Int else { return false }
        
        return isFirst == 0 ? true : false
    }
    
    func checkUserStatus() {
        status.accept(UserDefaultsManager.shared.checkUserDefatuls())
    }
    
    func setLocationAuth() {
        UserDefaultsManager.shared.setValue(value: LocationAuthStatus.restriced.rawValue, type: .locationAuth) //0으로 세팅
    }
    
    func removeUserDefaults() {
        UserDefaultsManager.shared.removeSomeValue()
    }
}
