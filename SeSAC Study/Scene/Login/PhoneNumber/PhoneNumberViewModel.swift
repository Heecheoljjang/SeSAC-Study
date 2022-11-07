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
    
    var sendAuthCheck = PublishRelay<Bool>()
    
    var phoneNumber = BehaviorRelay<String>(value: "")
    
    func sendPhoneAuth() {
        
        Auth.auth().languageCode = "kr"
//        let phoneNumber = phoneNumber.value
        let phoneNumber = "+829876543210"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            if let error = error {
                print(error.localizedDescription) //따로 처리해주기
                self?.sendAuthCheck.accept(false)
            }
            print("verificationID: \(verificationID)")
            
        }
    }
    
    func setPhoneNumber(number: String) {
        phoneNumber.accept(number)
    }
}
