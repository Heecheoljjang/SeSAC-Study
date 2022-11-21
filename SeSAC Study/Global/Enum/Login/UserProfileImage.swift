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
}
