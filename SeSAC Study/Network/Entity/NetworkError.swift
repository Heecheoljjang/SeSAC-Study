//
//  NetworkError.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation

enum NetworkError: Int, Error {
    case signUpSuccess = 200
    case alreadyExistUser = 201
    case invalidNickname = 202
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum NetworkErrorString: String {
    case signUpSuccess
    case alreadyExistUser
    case invalidNickname
    case tokenError
    case signUpRequired
    case serverError
    case clientError
}
