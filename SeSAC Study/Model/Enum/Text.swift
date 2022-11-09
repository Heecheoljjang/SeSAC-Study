//
//  Text.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import Foundation

enum LoginText {
    case phoneNumber, phoneAuth, nickName, birthday, email, gender
    
    var message: String {
        switch self {
        case .phoneNumber:
            return "새싹 서비스 이용을 위해 휴대폰 번호를 입력해 주세요"
        case .phoneAuth:
            return "인증번호가 문자로 전송되었어요"
        case .nickName:
            return "닉네임을 입력해 주세요"
        case .birthday:
            return "생년월일을 알려주세요"
        case .email:
            return "이메일을 입력해 주세요"
        case .gender:
            return "성별을 선택해 주세요"
        }
    }
    
    var placeholder: String {
        switch self {
        case .phoneNumber:
            return "휴대폰 번호(-없이 숫자만 입력)"
        case .phoneAuth:
            return "인증번호 입력"
        case .nickName:
            return "10자 이내로 입력"
        case .birthday, .gender:
            return ""
        case .email:
            return "SeSAC@email.com"
        }
    }
    
    var detailMessage: String {
        switch self {
        case .phoneNumber, .phoneAuth, .nickName, .birthday:
            return ""
        case .email:
            return "휴대폰 번호 변경 시 인증을 위해 사용해요"
        case .gender:
            return "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        }
    }
}

enum ButtonTitle {
    static let authButtonTitle = "인증 문자 받기"
    static let retryButtonTitle = "재전송"
    static let authCheckButtonTitle = "인증하고 시작하기"
    static let next = "다음"
}

enum ImageName {
    static let leftArrow = "arrow.left"
    static let man = "man"
    static let woman = "woman"
}

enum ErrorDescription {
    static let empty = "The phone auth credential was created with an empty SMS verification Code."
    static let wrongNumber = "The SMS verification code used to create the phone auth credential is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user."
    static let invalidId = "The verification ID used to create the phone auth credential is invalid."
}

enum DateString {
    case year, month, day
    
    var message: String {
        switch self {
        case .year:
            return "년"
        case .month:
            return "월"
        case .day:
            return "일"
        }
    }
    
    var placeholder: String {
        switch self {
        case .year:
            return "1990"
        case .month:
            return "1"
        case .day:
            return "1"
        }
    }
}
