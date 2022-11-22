//
//  ActionType.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/22.
//

import Foundation

enum MyInfoActionType {
    case update, updateFail, withdraw, withdrawFail
    
    var message: String {
        switch self {
        case .update:
            return "정보 수정 완료"
        case .updateFail:
            return "정보 수정 실패"
        case .withdraw:
            return "회원탈퇴 성공"
        case .withdrawFail:
            return "회원탈퇴 실패"
        }
    }
}
