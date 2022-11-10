//
//  SignUp.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation

struct SignUp: Codable {
    let phoneNumber: String
    let fcmToken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber, nick, birth, email, gender
        case fcmToken = "FCMtoken"
    }
}
