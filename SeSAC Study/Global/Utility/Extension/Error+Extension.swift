//
//  Error+Extension.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation

extension Error {
    
    func fetchNetworkErrorString() -> NetworkErrorString {
        switch "\(self)" {
        case NetworkErrorString.signUpSuccess.rawValue:
            return .signUpSuccess
        case NetworkErrorString.alreadyExistUser.rawValue:
            return .alreadyExistUser
        case NetworkErrorString.invalidNickname.rawValue:
            return .invalidNickname
        case NetworkErrorString.tokenError.rawValue:
            return .tokenError
        case NetworkErrorString.signUpRequired.rawValue:
            return .signUpRequired
        case NetworkErrorString.serverError.rawValue:
            return .serverError
        default:
            return .clientError
        }
    }
}
