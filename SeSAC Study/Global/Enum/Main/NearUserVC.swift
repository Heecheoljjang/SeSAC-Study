//
//  NearUserVC.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/24.
//

import Foundation

enum NearUserVC {
    case around, received
    
    var title: String {
        switch self {
        case .around:
            return "주변 새싹"
        case .received:
            return "받은 요청"
        }
    }
}
