//
//  ShopVC.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/05.
//

import Foundation

enum ShopVC {
    case sesac, background
    
    var title: String {
        switch self {
        case .sesac:
            return "새싹"
        case .background:
            return "배경"
        }
    }
}
