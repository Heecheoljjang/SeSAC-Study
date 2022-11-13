//
//  UserDefaultsManager.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/08.
//

import Foundation

final class UserDefaultsManager {
    
    private init() {}
    
    static let shared = UserDefaultsManager()
        
    func setValue<T>(value: T, type: UserDefaultsKeys) {
        UserDefaults.standard.set(value, forKey: type.rawValue)
    }
    
    func fetchValue(type: UserDefaultsKeys) -> Any {
        switch type {
        case .idToken, .phoneNumber, .fcmToken, .nick, .birth, .email, .gender, .verificationId:
            return UserDefaults.standard.string(forKey: type.rawValue) ?? ""
        case .invalidNickname:
            return UserDefaults.standard.bool(forKey: type.rawValue)
        case .isFirst:
            return UserDefaults.standard.integer(forKey: type.rawValue)
        }
    }
    
    func removeValue(type: UserDefaultsKeys) {
        UserDefaults.standard.removeObject(forKey: type.rawValue)
    }
    
    func removeSomeValue() {
        //id토큰뺴고 다 지우기
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.fcmToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.nick.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.birth.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.email.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.gender.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.verificationId.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.invalidNickname.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.phoneNumber.rawValue)
    }
    
    //체크하는 메서드 여기서
    func checkUserDefatuls() -> UserStatus {
        let phoneNumber = fetchValue(type: .phoneNumber) as? String ?? ""
        let idToken = fetchValue(type: .idToken) as? String ?? ""
        
        if !phoneNumber.isEmpty && !idToken.isEmpty {
            return .onlyFirebase
        }
        if !idToken.isEmpty && phoneNumber.isEmpty {
            return .registered
        }
        return .onboarding
    }
}
