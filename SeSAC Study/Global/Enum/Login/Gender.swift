//
//  Gender.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/10.
//

import Foundation

enum Gender {
    case man, woman
    
    var text: String {
        switch self {
        case .man:
            return "남자"
        case .woman:
            return "여자"
        }
    }
    var value: Int {
        switch self {
        case .man:
            return 1
        case .woman:
            return 0
        }
    }
    
}

enum GenderStatus {
    case selected, unselected
    
    var message: String {
        switch self {
        case .selected:
            return "성공"
        case .unselected:
            return "성별을 선택해주세요."
        }
    }
}
