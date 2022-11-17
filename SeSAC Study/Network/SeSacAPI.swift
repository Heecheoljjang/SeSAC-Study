//
//  SeSacAPI.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation
import Alamofire

enum SeSacAPI {
    
    static let baseUrl = "http://api.sesac.co.kr:1207/"
    static let version = "v1/"
    
    case signIn
    case signUp(phoneNumber: String, fcmToken: String, nickname: String, birth: String, email: String, gender: Int)
    case withdraw
    case queue(lat: Double, lon: Double, studyList: [String])
    case queueSearch(lat: Double, lon: Double)
    case myQueueState
    
    var url: URL {
        switch self {
        case .signIn, .signUp:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)user")!
        case .withdraw:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)withdraw")!
        case .queue:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue")!
        case .queueSearch:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue/search")!
        case .myQueueState:
            return URL(string: "\(SeSacAPI.baseUrl)\(SeSacAPI.version)queue/myQueueState")!
        }
    }
    
    var headers: HTTPHeaders {
        guard let token = UserDefaultsManager.shared.fetchValue(type: .idToken) as? String else { return [] }
        
        switch self {
        case .signIn, .withdraw, .myQueueState:
            return ["idtoken": token]
        case .signUp, .queue, .queueSearch:
            return [
                "idtoken": token,
                "Content-Type": "application/x-www-form-urlencoded"
            ]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .signIn, .withdraw, .myQueueState:
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
        case .queue(let lat, let lon, let studyList):
            return [
                "lat": lat,
                "long": lon,
                "studylist": studyList
            ]
        case .queueSearch(let lat, let lon):
            return [
                "lat": lat,
                "long": lon,
            ]
        }
    }
}
