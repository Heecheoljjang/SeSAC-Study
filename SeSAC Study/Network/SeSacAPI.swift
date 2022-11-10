//
//  SeSacAPI.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation
import Alamofire

enum SeSacAPI {
    case signIn
    case signUp(phoneNumber: String, fcmToken: String, nickname: String, birth: String, email: String, gender: Int)
    case withdraw
    
    var url: URL {
        switch self {
        case .signIn, .signUp:
            return URL(string: "http://api.sesac.co.kr:1207/v1/user")!
        case .withdraw:
            return URL(string: "http://api.sesac.co.kr:1207/v1/user/withdraw")!
        }
    }
    
    var headers: HTTPHeaders {
        guard let token = UserDefaultsManager.shared.fetchValue(type: .idToken) as? String else { return [] }
        
        switch self {
        case .signIn, .withdraw:
            return ["idtoken": token]
        case .signUp:
            return [
                "idtoken": token,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .signIn, .withdraw:
            return nil
        case .signUp(let phoneNumber, let fcmToken, let nickname, let birth, let email, let gender):
            return [
                "phoneNumber": phoneNumber,
                "FCMtoken": fcmToken,
                "nick": nickname,
                "birth": birth,
                "email": email,
                "gender": gender
            ]
        }
    }
}
