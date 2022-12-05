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
    static let accept = "수락하기"
    static let total = "전체"
    static let man = "남자"
    static let woman = "여자"
    static let searchSesac = "새싹 찾기"
    static let stop = "찾기중단"
    static let changeStudy = "스터디 변경하기"
    static let registerReview = "리뷰 등록하기"
    static let saveShop = "저장하기"
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
    static let searchDefault = "searchDefault"
    static let searchMatching = "searchMatching"
    static let searchMatched = "searchMatched"
    static let gps = "place"
    static let centerAnnotation = "map_marker"
    static let xmark = "xmark"
    static let ellipsis = "ellipsis"
    static let bell = "bell"
    static let retry = "retry"
    
    static let sesacFace = "sesacFace"
    static let notice = "notice"
    static let faq = "faq"
    static let qna = "qna"
    static let alarm = "setting_alarm"
    static let permit = "permit"
    static let emptySesac = "emptySesac"
    static let sendButton = "sendButton"
    static let greenButton = "greenSendButton"
    static let report = "siren"
    static let cancelStudy = "cancel_match"
    static let review = "write"
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
    case todayChat, notTodayChat
    
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

enum SeSacLocation {
    case lat, lon
    
    var value: Double {
        switch self {
        case .lat:
            //위도
            return 37.517819364682694
        case .lon:
            //경도
            return 126.88647317074734
        }
    }
}

enum Annotation: Int {
    case basic, strong, mint, purple, gold
    
    var imageName: String {
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

enum PlaceHolder {
    static let searchBar = "띄어쓰기로 복수 입력이 가능해요"
    static let review = "첫 리뷰를 기다리는 중이에요!"
    static let myInfoStudy = "스터디를 입력해주세요"
    static let chatting = "메세지를 입력하세요"
    static let registerReview = "자세한 피드백은 다른 새싹들에게 도움이 됩니다\n(500자 이내 작성)"
}

enum SearchStudySection {
    static let around = "지금 주변에는"
    static let myList = "내가 하고 싶은"
}

enum ToastMessage {
    static let alreadyExistStudy = "이미 등록된 스터디가 있습니다."
    static let tooMany = "최대 8개까지 등록할 수 있습니다."
    static let tooLong = "각 스터디는 최대 8글자까지 작성할 수 있습니다."
    static let tooShort = "최소 1글자 이상 작성해야합니다."
    static let noReviewSelected = "최소 한 가지 이상의 항목을 선택해야 합니다."
}

enum SettingViewTitle {
    static let gender = "내 성별"
    static let study = "자주 하는 스터디"
    static let search = "내 번호 검색 허용"
    static let targetAge = "상대방 연령대"
    static let withdraw = "회원탈퇴"
}

enum BackgroundImage: Int {
    case first, second, third, fourth, fifth, sixth, seventh, eighth, ninth
    
    var imageName: String {
        switch self {
        case .first:
            return "sesac_background_1"
        case .second:
            return "sesac_background_2"
        case .third:
            return "sesac_background_3"
        case .fourth:
            return "sesac_background_4"
        case .fifth:
            return "sesac_background_5"
        case .sixth:
            return "sesac_background_6"
        case .seventh:
            return "sesac_background_7"
        case .eighth:
            return "sesac_background_8"
        case .ninth:
            return "sesac_background_9"
        }
    }
}

enum AlertText {
    case withdraw, location, locationAuth
    
    var title: String {
        switch self {
        case .withdraw:
            return "정말 탈퇴하시겠습니까?"
        case .location:
            return "위치를 가져오지 못했습니다."
        case .locationAuth:
            return "위치 서비스 사용 불가"
        }
    }
    
    var message: String {
        switch self {
        case .withdraw:
            return "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ"
        case .location:
            return "다시 시도해주세요."
        case .locationAuth:
            return ""
        }
    }
}

enum NavigationBarTitle {
    case sesacSearch, sesacReview, shop, friends, addSesac, info, manageInfo
    
    var title: String {
        switch self {
        case .sesacSearch:
            return "새싹 찾기"
        case .sesacReview:
            return "새싹 리뷰"
        case .shop:
            return "새싹샵"
        case .friends:
            return "새싹 친구"
        case .addSesac:
            return "새싹 추가"
        case .info:
            return "내 정보"
        case .manageInfo:
            return "정보 관리"
        }
    }
}

enum CustomAlert {
    case studyRequest, studyAccept, matched, alreadyCanceled
    
    var title: String {
        switch self {
        case .studyRequest:
            return "스터디를 요청할게요!"
        case .studyAccept:
            return "스터디를 수락할까요?"
        case .matched:
            return "스터디를 취소하겠습니까?"
        case .alreadyCanceled:
            return "스터디를 종료하시겠습니까?"
        }
    }
    
    var message: String {
        switch self {
        case .studyRequest:
            return "상대방이 요청을 수락하면\n채팅창에서 대화를 나눌 수 있어요"
        case .studyAccept:
            return "요청을 수락하면\n 채팅창에서 대화를 나눌 수 있어요"
        case .matched:
            return "스터디를 취소하시면 패널티가 부과됩니다"
        case .alreadyCanceled:
            return "상대방이 스터디를 취소했기때문에\n 패널티가 부과되지 않습니다"
        }
    }
    
    var cancelTitle: String {
        return "취소"
    }
    
    var okTitle: String {
        return "확인"
    }
}
