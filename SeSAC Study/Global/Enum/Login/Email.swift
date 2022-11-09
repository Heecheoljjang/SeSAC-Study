//
//  Email.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/10.
//

import Foundation

enum EmailStatus {
    case valid, invalid
    
    var message: String {
        switch self {
        case .valid:
            return "성공"
        case .invalid:
            return "이메일 형식이 올바르지 않습니다."
        }
    }
}
