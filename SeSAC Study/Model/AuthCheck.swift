//
//  AuthCheck.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/08.
//

import Foundation

enum AuthCheck {
    case wrongNumber
    case fail
    case manyRequest
    case success
    
    var message: String {
        switch self {
        case .wrongNumber:
            return "잘못된 전화번호 형식입니다."
        case .fail:
            return "에러가 발생했습니다. 다시 시도해주세요."
        case .manyRequest:
            return "과도한 인증 시도가 있었습니다. 나중에 다시 시도해주세요."
        case .success:
            return "전호번호 인증 시작"
        }
    }
}
