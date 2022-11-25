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
        switch type {
        case .userInfo:
            print("유저인뽀 인코딩하는중")
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(value as? SignIn) {
                print("인코딩데이터: \(encoded)")
                UserDefaults.standard.set(encoded, forKey: type.rawValue)
            }
        default:
            UserDefaults.standard.set(value, forKey: type.rawValue)
        }
    }
    
    func fetchValue(type: UserDefaultsKeys) -> Any {
        switch type {
        case .idToken, .phoneNumber, .fcmToken, .nick, .birth, .email, .gender, .verificationId:
            return UserDefaults.standard.string(forKey: type.rawValue) ?? ""
        case .invalidNickname:
            return UserDefaults.standard.bool(forKey: type.rawValue)
        case .lat, .long:
            return UserDefaults.standard.double(forKey: type.rawValue)
        case .userInfo:
            guard let infoData = UserDefaults.standard.object(forKey: type.rawValue) as? Data else { return "" }
            let decoder = JSONDecoder()
            guard let decodedData = try? decoder.decode(SignIn.self, from: infoData) else { return "" }
            print("디코딩한 데이터: \(decodedData)")
            return decodedData
        }
    }
    
    func removeValue(type: UserDefaultsKeys) {
        UserDefaults.standard.removeObject(forKey: type.rawValue)
    }
    
    func removeSomeValue() {
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.fcmToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.nick.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.birth.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.email.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.gender.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.verificationId.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.invalidNickname.rawValue)
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.phoneNumber.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userInfo.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.lat.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.long.rawValue)
    }
    
    func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
    
    func checkIdTokenIsEmpty() -> Bool {
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaultsKeys.idToken.rawValue) else { return true }
        return idToken.isEmpty ? true : false
    }
    
    func fetchLocation() -> [Double] {
        guard let lat = fetchValue(type: .lat) as? Double, let long = fetchValue(type: .long) as? Double else {
            print("위치 못가져왔어요 여기는 유저디폴트 fetchLocation")
            return [] }
        return [lat, long]
    }
}
