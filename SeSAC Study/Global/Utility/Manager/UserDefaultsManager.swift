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
        case .idToken, .phoneNumber, .fcmToken, .nick, .birth, .email:
            return UserDefaults.standard.string(forKey: type.rawValue) ?? ""
        case .gender:
            return UserDefaults.standard.integer(forKey: type.rawValue)
        }
    }
}
