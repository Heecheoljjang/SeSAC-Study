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
        Auth.auth().languageCode = "kr"
        let phoneNumber = phoneNumber.value.changeFormat()
//        let phoneNumber = "+829876543210"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            if let error = error {
                print(error.localizedDescription) //따로 처리해주기
                self?.sendAuthCheck.accept(AuthCheck.fail)
                return
            }
            guard let verificationID else { return }
            UserDefaultsManager.shared.setValue(value: verificationID, type: .idToken)
            UserDefaultsManager.shared.setValue(value: phoneNumber, type: .phoneNumber)
            self?.sendAuthCheck.accept(AuthCheck.success)
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
        UserDefaultsManager.shared.setValue(value: value, type: .phoneNumber)
    }
}
