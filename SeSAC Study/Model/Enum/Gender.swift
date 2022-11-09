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
}
