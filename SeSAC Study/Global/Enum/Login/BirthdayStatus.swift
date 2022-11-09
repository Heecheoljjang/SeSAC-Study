//
//  BirthdayStatus.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation

enum BirthdayStatus {
    case enable, disable
    
    var message: String {
        switch self {
        case .enable:
            return "성공"
        case .disable:
            return "새싹스터디는 만 17세 이상만 사용할 수 있습니다."
        }
    }
}
