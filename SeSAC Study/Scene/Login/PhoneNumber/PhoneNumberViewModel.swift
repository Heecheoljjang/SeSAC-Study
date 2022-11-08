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
    
//    var verificationId = BehaviorRelay<String>(value: "")
    
    func sendPhoneAuth() {
        
        if buttonStatus.value == ButtonStatus.disable {
            sendAuthCheck.accept(AuthCheck.wrongNumber)
            return
        }
        Auth.auth().languageCode = "kr"
//        let phoneNumber = phoneNumber.value.changeFormat()
        let phoneNumber = "+829876543210"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            if let error = error {
                print(error.localizedDescription) //따로 처리해주기
                self?.sendAuthCheck.accept(AuthCheck.fail)
                return
            }
            print("verificationID: \(verificationID)")
            guard let verificationID else { return }
//            self?.verificationId.accept(verificationID)
            UserDefaultsManager.shared.setIdValue(value: verificationID)
            self?.sendAuthCheck.accept(AuthCheck.success)
        }
    }
    
    func setPhoneNumber(number: String) {
        phoneNumber.accept(number)
    }
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }
    
//    func sendVerificationId(vc: PhoneAuthViewController, id: String) {
//        print("실행됨, value: \(verificationId.value)")
//        vc.viewModel.verificationId.accept(id)
//    }
}
