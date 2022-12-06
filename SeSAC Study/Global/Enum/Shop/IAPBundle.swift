//
//  IAPBundle.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/12/06.
//

import Foundation

enum IAPBundle {
    
    enum Sesac: Int {
        case basic, strong, mint, purple, gold
        
        var bundle: String {
            switch self {
            case .basic:
                return ""
            case .strong:
                return "com.memolease.sesac1.sprout1"
            case .mint:
                return "com.memolease.sesac1.sprout2"
            case .purple:
                return "com.memolease.sesac1.sprout3"
            case .gold:
                return "com.memolease.sesac1.sprout4"
            }
        }
    }
    
    enum Background: Int {
        case skyPark, city, nightWalk, dayWalk, stage, latin, training, musician
        
        var bundle: String {
            switch self {
            case .skyPark:
                return ""
            case .city:
                return "com.memolease.sesac1.background1"
            case .nightWalk:
                return "com.memolease.sesac1.background2"
            case .dayWalk:
                return "com.memolease.sesac1.background3"
            case .stage:
                return "com.memolease.sesac1.background4"
            case .latin:
                return "com.memolease.sesac1.background5"
            case .training:
                return "com.memolease.sesac1.background6"
            case .musician:
                return "com.memolease.sesac1.background7"
            }
        }
    }
}
