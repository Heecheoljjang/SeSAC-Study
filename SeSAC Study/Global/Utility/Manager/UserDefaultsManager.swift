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
        case .isFirst, .onlyFirebase, .existUser,.locationAuth:
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
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.phoneNumber.rawValue)
    }
    
    //체크하는 메서드 여기서
    func checkUserDefatuls() -> UserStatus {
//        let phoneNumber = fetchValue(type: .phoneNumber) as? String ?? ""
//        let idToken = fetchValue(type: .idToken) as? String ?? ""
//
//        if !phoneNumber.isEmpty && !idToken.isEmpty {
//            return .onlyFirebase
//        }
//        if !idToken.isEmpty && phoneNumber.isEmpty {
//            return .registered
//        }
//        return .onboarding
        guard let isFirst = fetchValue(type: .isFirst) as? Int,
              let onlyFirebase = fetchValue(type: .onlyFirebase) as? Int,
              let existUser = fetchValue(type: .existUser) as? Int else { return .onboarding }
        print(isFirst, onlyFirebase, existUser)
        
        //온보딩을 처음봄
        if isFirst == 0 {
            return .onboarding
        }
        //회원가입을 끝낸적이 있음
        if existUser == 1 {
            return .registered
        }
        //파이어베이스 인증한적없고 회원가입을 끝낸적이없으므로
        if onlyFirebase == 0 {
            return .registered
        }
        return .onlyFirebase
    }
    
    func checkLocationAuth() -> Bool {
        guard let authValue = fetchValue(type: .locationAuth) as? Int else { return false }
        print("유저디폴트에서 불러온 값 \(authValue)")
        guard let auth = LocationAuthStatus(rawValue: authValue) else { return false }
        print("숫자로 가져온 상태값 \(auth)")
        return auth == .restriced ? false : true
    }
}
