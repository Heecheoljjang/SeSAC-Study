//
//  NetworkError.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation

enum NetworkError {
    case LoginError
    case SesacRequestError
    case SesacCancelError
    case SesacSearchError
    case QueueStateError
}

enum LoginError: Int, Error {
    case signUpSuccess = 200
    case alreadyExistUser = 201
    case invalidNickname = 202
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum SesacRequestError: Int, Error {
    case searchSuccess = 200
    case dangerUser = 201
    case firstPenalty = 203
    case secondPenalty = 204
    case thirdPenalty = 205
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum SesacCancelError: Int, Error {
    case cancelSuccess = 200
    case alreadyCancel = 201
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum SesacSearchError: Int, Error {
    case searchSuccess = 200
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum QueueStateError: Int, Error {
    case checkSuccess = 200
    case normalState = 201
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum LoginErrorString: String {
    case signUpSuccess
    case alreadyExistUser
    case invalidNickname
    case tokenError
    case signUpRequired
    case serverError
    case clientError
    
    var message: String {
        switch self {
        case .signUpSuccess:
            return "회원가입 성공"
        case .alreadyExistUser:
            return "이미 가입된 회원입니다."
        case .invalidNickname:
            return "닉네임 이미 있음"
        case .tokenError:
            return "에러가 발생하였습니다."
        case .signUpRequired:
            return "회원가입이 필요합니다"
        case .serverError:
            return "서버에 이상이 있습니다."
        case .clientError:
            return "에러가 발생하였습니다."
        }
    }
}
