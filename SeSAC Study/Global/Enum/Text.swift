//
//  Text.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import Foundation

//MARK: - 여유될때 enum 꼭 정리하기!

enum LoginText {
    case phoneNumber, phoneAuth, nickName, birthday, email, gender
    
    var message: String {
        switch self {
        case .phoneNumber:
            return "새싹 서비스 이용을 위해\n 휴대폰 번호를 입력해 주세요"
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
    static let start = "시작하기"
    static let save = "저장"
    static let requestFriend = "요청하기"
}

enum ImageName {
    static let leftArrow = "arrow.left"
    static let man = "man"
    static let woman = "woman"
    static let splash = "splash_logo"
    static let backButton = "arrow"
    static let rightChevron = "rightChevron"
    static let upChevron = "upChevron"
    static let downChevron = "downChevron"
    static let background = "sesac_bg_01"
}

enum ProfileImage {
    static let background = "sesac_bg_01"
    static let sesacFirst = "sesac_face_1"
}

enum TabBarData: String {
    case home, shop, friend, info
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .shop:
            return "새싹샵"
        case .friend:
            return "새싹친구"
        case .info:
            return "내정보"
        }
    }
    var baseIcon: String {
        switch self {
        case .home:
            return "home"
        case .shop:
            return "shop"
        case .friend:
            return "friend"
        case .info:
            return "info"
        }
    }
    var selectedIcon: String {
        switch self {
        case .home:
            return "homeSelected"
        case .shop:
            return "shopSelected"
        case .friend:
            return "friendSelected"
        case .info:
            return "infoSelected"
        }
    }
}

enum InfoTable {
    case notice, faq, permit, alarm, qna
    
    var title: String {
        switch self {
        case .notice:
            return "공지사항"
        case .faq:
            return "자주 묻는 질문"
        case .permit:
            return "1:1 문의"
        case .alarm:
            return "알림 설정"
        case .qna:
            return "이용약관"
        }
    }
    
    var icon: String {
        switch self {
        case .notice:
            return "notice"
        case .faq:
            return "faq"
        case .permit:
            return "permit"
        case .alarm:
            return "setting_alarm"
        case .qna:
            return "qna"
        }
    }
}

enum DateString {
    case year, month, day, date, dateString
    
    var message: String {
        switch self {
        case .year:
            return "년"
        case .month:
            return "월"
        case .day:
            return "일"
        default:
            return ""
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
        default:
            return ""
        }
    }
}

enum ErrorText {
    static let message = "에러가 발생하였습니다. 다시 시도해주세요."
}

enum OnboardingData {
    case first, second, third
    
    var message: String {
        switch self {
        case .first:
            return "위치 기반으로 빠르게 주위 친구를 확인"
        case .second:
            return "스터디를 원하는 친구를 찾을 수 있어요"
        case .third:
            return "SeSAC Study"
        }
    }
    
    var colorText: String {
        switch self {
        case .first:
            return "위치 기반"
        case .second:
            return "스터디를 원하는 친구"
        case .third:
            return ""
        }
    }
    
    var imageName: String {
        switch self {
        case .first:
            return "onboarding_img1"
        case .second:
            return "onboarding_img2"
        case .third:
            return "onboarding_img3"
        }
    }
}

enum CardViewSection {
    case title, study, review
    
    var titleString: String {
        switch self {
        case .title:
            return "새싹 타이틀"
        case .study:
            return "하고 싶은 스터디"
        case .review:
            return "새싹 리뷰"
        }
    }
    
    var placeHolder: String {
        switch self {
        case .title:
            return ""
        case .study:
            return ""
        case .review:
            return "첫 리뷰를 기다리는 중이에요!"
        }
    }
}

enum SeSacTitle {
    case good, time, fast, kind, expert, helpful
    
    var buttonTitle: String {
        switch self {
        case .good:
            return "좋은 매너"
        case .time:
            return "정확한 시간 약속"
        case .fast:
            return "빠른 응답"
        case .kind:
            return "친절한 성격"
        case .expert:
            return "능숙한 실력"
        case .helpful:
            return "유익한 시간"
        }
    }
}
