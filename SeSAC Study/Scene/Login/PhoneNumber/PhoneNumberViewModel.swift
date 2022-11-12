//
//  PhoneNumberViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa

final class PhoneNumberViewModel {
    
    var sendAuthCheck = PublishRelay<AuthCheck>()

    var phoneNumber = BehaviorRelay<String>(value: "")
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
        
    func sendPhoneAuth() {
        
        if buttonStatus.value == ButtonStatus.disable {
            sendAuthCheck.accept(AuthCheck.wrongNumber)
            return
        }

        let phoneNumber = phoneNumber.value.changeFormat()
        FirebaseManager.shared.fetchVerificationId(phoneNumber: phoneNumber) { [weak self] value in
            switch value {
            case .wrongNumber:
                self?.sendAuthCheck.accept(.wrongNumber)
            case .fail:
                self?.sendAuthCheck.accept(.fail)
            case .manyRequest:
                self?.sendAuthCheck.accept(.manyRequest)
            case .success:
                self?.sendAuthCheck.accept(.success)
            }
        }
    }
    
    func setPhoneNumber(number: String) {
        phoneNumber.accept(number.replacingOccurrences(of: "-", with: ""))
    }
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }
    
    func checkPhoneNumber(number: String) {
        let regexStr = "^01[0-9][0-9]{7,8}$"
        number.replacingOccurrences(of: "-", with: "").range(of: regexStr, options: .regularExpression) != nil ? buttonStatus.accept(.enable) : buttonStatus.accept(.disable)
    }
    
    func savePhoneNumber(value: String) {
        let number = value.replacingOccurrences(of: "-", with: "")
        UserDefaultsManager.shared.setValue(value: number.changeFormat(), type: .phoneNumber)
    }
    
    func setIsFirst() {
        UserDefaultsManager.shared.setValue(value: 1, type: .isFirst)
    }
}
