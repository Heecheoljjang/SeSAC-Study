//
//  FirebaseManager.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/11.
//

import Foundation
import FirebaseAuth

final class FirebaseManager {
    private init() {}
    
    static let shared = FirebaseManager()
    
    func fetchVerificationId(phoneNumber: String, completionHandler: @escaping ((Bool)->())) {
        Auth.auth().languageCode = "kr"
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("verificationID에러: \(error)")
                completionHandler(false)
                return
            }
            print("verificationID성공")
            guard let verificationID else { return }
            UserDefaultsManager.shared.setValue(value: verificationID, type: .verificationId)
            completionHandler(true)
        }
    }
    
    func checkAuthCode(verId: String, authCode: String, completionHandler: @escaping((Result<Bool, Error>)->())) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verId, verificationCode: authCode)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("인증실패고")
                completionHandler(.failure(error))
                return
            }
            print("인증성공이고")
            completionHandler(.success(true))
        }
    }
    
    func fetchIdToken(completionHandler: @escaping ((Result<String, Error>) -> ())) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print("아이디토큰가져오기 에러")
                completionHandler(.failure(error))
                return
            }
            guard let idToken else { return }
            UserDefaultsManager.shared.setValue(value: idToken, type: .idToken)
            print(UserDefaultsManager.shared.fetchValue(type: .idToken) )
            completionHandler(.success(idToken))
        }
    }
}
