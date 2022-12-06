//
//  NetworkError.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation

enum LoginError: Int, Error {
    case signUpSuccess = 200
    case alreadyExistUser = 201
    case invalidNickname = 202
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .signUpSuccess:
            return "회원가입 성공"
        case .alreadyExistUser:
            return "이미 가입된 회원입니다."
        case .invalidNickname:
            return "닉네임 이미 있음"
        case .tokenError:
            return "에러가 발생하였습니다."
        case .signUpRequired:
            return "회원가입이 필요합니다"
        case .serverError:
            return "서버에 이상이 있습니다."
        case .clientError:
            return "에러가 발생하였습니다."
        }
    }
}

enum WithdrawError: Int, Error {
    case withdrawSuccess = 200
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum UpdateError: Int, Error {
    case updateSuccess = 200
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum SesacRequestError: Int, Error {
    case searchSuccess = 200
    case dangerUser = 201
    case firstPenalty = 203
    case secondPenalty = 204
    case thirdPenalty = 205
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .dangerUser:
            return "신고가 누적되어 이용하실 수 없습니다."
        case .firstPenalty:
            return "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다."
        case .secondPenalty:
            return "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다."
        case .thirdPenalty:
            return "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다."
        default:
            return "오류가 발생했습니다. 다시 시도해주세요."
        }
    }
}

enum SesacCancelError: Int, Error {
    case cancelSuccess = 200
    case alreadyCancel = 201
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .cancelSuccess:
            return "성공"
        case .alreadyCancel:
            return "누군가와 스터디를 함께하기로 약속하셨어요!"
        default:
            return "에러가 발생하였습니다. 다시 시도해주세요."
        }
    }
}

enum SesacSearchError: Int, Error {
    case searchSuccess = 200
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum QueueStateError: Int, Error {
    case checkSuccess = 200
    case normalState = 201
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum StudyRequestError: Int {
    case requestSuccess = 200
    case studyAccept = 201
    case cancelStudy = 202
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .requestSuccess:
            return "스터디 요청을 보냈습니다."
        case .studyAccept:
            return "상대방도 스터디를 요청하여 매칭되었습니다. 잠시 후 채팅방으로 이동합니다."
        case .cancelStudy:
            return "상대방이 스터디 찾기를 그만두었습니다."
        case .tokenError:
            return "에러가 발생하였습니다."
        case .signUpRequired:
            return "회원가입이 필요합니다"
        case .serverError:
            return "서버에 이상이 있습니다."
        case .clientError:
            return "에러가 발생하였습니다."
        }
    }
}

enum StudyAcceptError: Int {
    case acceptSuccess = 200
    case alreadyOtherMatched = 201
    case cancelStudy = 202
    case alreadyMatched = 203
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .acceptSuccess:
            return "수락 성공"
        case .alreadyOtherMatched:
            return "상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다."
        case .cancelStudy:
            return "상대방이 스터디 찾기를 그만두었습니다."
        case .alreadyMatched:
            return "앗! 누군가가 나의 스터디를 수락하였어요!"
        case .tokenError:
            return "에러가 발생하였습니다."
        case .signUpRequired:
            return "회원가입이 필요합니다"
        case .serverError:
            return "서버에 이상이 있습니다."
        case .clientError:
            return "에러가 발생하였습니다."
        }
    }
}

enum StudyDodgeError: Int {
    case dodgeSuccess = 200
    case wrongUid = 201
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
    
    var errorMessage: String {
        return "에러가 발생하였습니다."
    }
}

enum SendChattingError: Int {
    case sendSuccess = 200
    case sendFailure = 201
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
    
    var message: String {
        switch self {
        case .sendSuccess:
            return "성공"
        case .sendFailure:
            return "스터디가 종료되어 채팅을 전송할 수 없습니다"
        default:
            return "에러가 발생하였습니다."
        }
    }
}

enum FetchChattingError: Int {
    case fetchSuccess = 200
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
}

enum RegisterError: Int {
    case registerSuccess = 200
    case tokenError = 401
    case signUpRequired = 406
    case serverError = 500
    case clientError = 501
    var errorMessage: String {
        return "에러가 발생하였습니다."
    }
}

//MARK: Shop은 묶어보기

enum ShopNetworkError {
    enum MyInfo: Int {
        case getInfoSuccess = 200
        case tokenError = 401
        case signUpRequired = 406
        case serverError = 500
        case clientError = 501
    }

    enum UpdateShopItem: Int {
        case updateSuccess = 200
        case beforePurchase = 201
        case tokenError = 401
        case signUpRequired = 406
        case serverError = 500
        case clientError = 501
        
        var message: String {
            switch self {
            case .updateSuccess:
                return "성공적으로 저장되었습니다"
            case .beforePurchase:
                return "구매가 필요한 아이템이 있어요"
            default:
                return "에러가 발생하였습니다."
            }
        }
    }
    
    enum PurchaseShopItem: Int {
        case purchaseSuccess = 200
        case invalidReceipt
        case tokenError = 401
        case signUpRequired = 406
        case serverError = 500
        case clientError = 501
        
        var message: String {
            switch self {
            case .purchaseSuccess:
                return "성공적으로 구매되었습니다"
            default:
                return "에러가 발생하였습니다."
            }
        }
    }
}

