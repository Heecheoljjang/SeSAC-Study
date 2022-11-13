//
//  NicknameViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

final class NickNameViewModel {
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: .disable)
    
    var isEnable = PublishRelay<NicknameCheck>()
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }
    
    func checkIsEnable() {
        buttonStatus.value == .enable ? isEnable.accept(.success) : isEnable.accept(.lengthFail)
    }
    
    func setNickname(name: String) {
        UserDefaultsManager.shared.setValue(value: name, type: .nick)
    }
    
    func checkInvalid() -> Bool {
        guard let invalidStatus = UserDefaultsManager.shared.fetchValue(type: .invalidNickname) as? Bool else { print("뭘까")
            return false }
        print(invalidStatus)
        return invalidStatus
    }
    
    func setInvalid() {
        UserDefaultsManager.shared.setValue(value: false, type: .invalidNickname)
    }
    
    func checkUserDefaultsExist() -> Bool {
        
        let nickname = UserDefaultsManager.shared.fetchValue(type: .nick) as? String ?? ""
        return nickname.isEmpty ? false : true
    }
    
    func fetchNickname() -> String {
        return UserDefaultsManager.shared.fetchValue(type: .nick) as? String ?? ""
    }
}
