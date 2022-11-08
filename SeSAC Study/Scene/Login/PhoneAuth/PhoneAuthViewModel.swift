//
//  PhoneAuthViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

final class PhoneAuthViewModel {
    
//    var verificationId = BehaviorRelay<String>(value: "")
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
    
    var authCode = BehaviorRelay(value: "")
    
    var authCodeCheck = PublishRelay<AuthCodeCheck>()
    
    func checkAuth() {
        
        let id = UserDefaultsManager.shared.fetchIdValue()
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: authCode.value)
        
        if buttonStatus.value == ButtonStatus.disable {
            authCodeCheck.accept(AuthCodeCheck.wrongCode)
            return
        }
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                print("에러")
                self?.checkError(error: error.localizedDescription)
                return
            }
            guard let authResult else { return }
            self?.authCodeCheck.accept(AuthCodeCheck.success)
            print(authResult)
        }
    }
    
    //MARK: 타임아웃 메서드 추가해야됨
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }
    
    func setAuthCode(code: String) {
        authCode.accept(code)
    }
    
    func checkError(error: String) {
        if error == ErrorDescription.invalidId {
            authCodeCheck.accept(.fail)
        } else {
            authCodeCheck.accept(.wrongCode)
        }
    }
}
