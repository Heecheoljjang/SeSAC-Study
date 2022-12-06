//
//  ProfileImage.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/21.
//

import Foundation

enum UserProfileImage: Int {
    case basic, strong, mint, purple, gold
    
    var image: String {
        switch self {
        case .basic:
            return "sesac_face_1"
        case .strong:
            return "sesac_face_2"
        case .mint:
            return "sesac_face_3"
        case .purple:
            return "sesac_face_4"
        case .gold:
            return "sesac_face_5"
        }
    }
    var name: String {
        switch self {
        case .basic:
            return "기본 새싹"
        case .strong:
            return "튼튼 새싹"
        case .mint:
            return "민트 새싹"
        case .purple:
            return "퍼플 새싹"
        case .gold:
            return "골드 새싹"
        }
    }
    var info: String {
        switch self {
        case .basic:
            return "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다."
        default:
            return ""
        }
    }
}
