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

enum NoSesacViewLabel {
    case noAround, received
    
    var bigLabelText: String {
        switch self {
        case .noAround:
            return "아쉽게도 주변에 새싹이 없어요ㅠ"
        case .received:
            return "아직 받은 요청이 없어요ㅠ"
        }
    }
    
    var smallLabelText: String {
        return "스터디를 변경하거나 조금만 더 기다려주세요!"
    }
}
