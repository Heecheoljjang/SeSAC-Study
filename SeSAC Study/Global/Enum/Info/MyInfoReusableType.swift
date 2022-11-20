//
//  MyInfoReusableType.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/20.
//

import Foundation

enum MyInfoReusableType {
    case notice, faq, qna, alarm, permit
    
    var labelText: String {
        switch self {
        case .notice:
            return "공지사항"
        case .faq:
            return "자주 묻는 질문"
        case .qna:
            return "1:1 문의"
        case .alarm:
            return "알림 설정"
        case .permit:
            return "이용약관"
        }
    }
    
    var imageName: String {
        switch self {
        case .notice:
            return ImageName.notice
        case .faq:
            return ImageName.faq
        case .qna:
            return ImageName.qna
        case .alarm:
            return ImageName.alarm
        case .permit:
            return ImageName.permit
        }
    }
}
