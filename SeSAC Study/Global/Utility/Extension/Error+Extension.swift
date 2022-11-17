//
//  Error+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation

extension Error {
    
    func fetchNetworkErrorString() -> LoginErrorString {
        switch "\(self)" {
        case LoginErrorString.signUpSuccess.rawValue:
            return .signUpSuccess
        case LoginErrorString.alreadyExistUser.rawValue:
            return .alreadyExistUser
        case LoginErrorString.invalidNickname.rawValue:
            return .invalidNickname
        case LoginErrorString.tokenError.rawValue:
            return .tokenError
        case LoginErrorString.signUpRequired.rawValue:
            return .signUpRequired
        case LoginErrorString.serverError.rawValue:
            return .serverError
        default:
            return .clientError
        }
    }
}
