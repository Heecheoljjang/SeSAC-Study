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
import Alamofire

final class PhoneAuthViewModel {
    
    //    var verificationId = BehaviorRelay<String>(value: "")
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
    
//    var authCode = BehaviorRelay(value: "")
    
    var authCodeCheck = PublishRelay<AuthCodeCheck>()
    
    var errorStatus = PublishRelay<NetworkErrorString>()
    
    func checkAuth(code: String) {
        
        guard let id = UserDefaultsManager.shared.fetchValue(type: .verificationId) as? String else { return }
        print(id)
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
        
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
            print("성공")
            guard let authResult else { return }
            
            self?.authCodeCheck.accept(AuthCodeCheck.success)
            print(authResult)
        }
    }
    
    //aythcodeCheck가 바뀌면 id토큰 받아오는 메서드 실행
    func fetchIdToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                print(error)
                return
            }
            //MARK: id토큰 받아오기까지 성공
            print("아이디토큰: \(idToken)")
            //서버통신해보기
            guard let idToken else { return }
            UserDefaultsManager.shared.setValue(value: idToken, type: .idToken)

            let api = SeSacAPI.signIn
            APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { result in
                switch result {
                case .success(let response):
                    //성공했으면 가입된 회원이므로 홈화면으로
                    print("성공했지요: \(response)")
                case .failure(let error):
                    //실패했으면 상태코드로 판단. 만약 406이라면 회원가입으로, 나머지는 오류라고
                    print(error.localizedDescription)
                    let errorStr = error.fetchNetworkErrorString()
                    self.errorStatus.accept(errorStr)
                }
            }
        }
        
        
        
    }
    
    //MARK: 타임아웃 메서드 추가해야됨
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }
    
//    func setAuthCode(code: String) {
//        authCode.accept(code)
//    }
    
    func checkError(error: String) {
        if error == ErrorDescription.invalidId {
            authCodeCheck.accept(.fail)
        } else {
            authCodeCheck.accept(.wrongCode)
        }
    }
    
    func setErrorStatus(status: NetworkErrorString) {
        errorStatus.accept(status)
    }
}
