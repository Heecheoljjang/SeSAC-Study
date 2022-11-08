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
    
    func setIdValue(value: String) {
        UserDefaults.standard.set(value, forKey: "id")
    }
    
    func fetchIdValue() -> String {
        return UserDefaults.standard.string(forKey: "id") ?? ""
    }
}
