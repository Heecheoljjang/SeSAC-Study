//
//  NicknameCheck.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation

enum NicknameCheck {
    case lengthFail
    case fail
    case success
    
    var message: String {
        switch self {
        case .lengthFail:
            return "닉네임은 1자 이상 10자 이내로 부탁드려요."
        case .fail:
            return "해당 닉네임은 사용할 수 없습니다."
        case .success:
            return "성공"
        }
    }
}
