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
        
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
        
    var authCodeCheck = PublishRelay<AuthCodeCheck>()
    
    var errorStatus = PublishRelay<NetworkErrorString>()
    
    func checkAuth(code: String) {
        
        guard let id = UserDefaultsManager.shared.fetchValue(type: .verificationId) as? String else { return }
        
        if buttonStatus.value == ButtonStatus.disable {
            authCodeCheck.accept(AuthCodeCheck.wrongCode)
            return
        }

        FirebaseManager.shared.checkAuthCode(verId: id, authCode: code) { [weak self] result in
            switch result {
            case .success(_):
                self?.authCodeCheck.accept(.success)
            case .failure(let error):
                print("에러에러에러에러에러: \(error.localizedDescription)")
                self?.checkError(error: error.localizedDescription)
            }
        }
    }
    
    func fetchIdToken() {
        FirebaseManager.shared.fetchIdToken { result in
            switch result {
            case .success(_):
                print("아이디토큰받아왔으므로 네트워크 통신하기")
                self.checkUser()
            case .failure(let error):
                print("아이디토큰 못받아옴 \(error)")
                return
            }
        }
    }
    
    private func checkUser() {
        let api = SeSacAPI.signIn
        APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { result in
            switch result {
            case .success(let response):
                //MARK: 성공했으면 가입된 회원이므로 홈화면으로
                print("성공했지요: \(response)")
                self.errorStatus.accept(.signUpSuccess)
            case .failure(let error):
                //실패했으면 상태코드로 판단. 만약 406이라면 회원가입으로, 나머지는 오류라고
                print("여기 실패입니다 \(error)")
                let errorStr = error.fetchNetworkErrorString()
                self.errorStatus.accept(errorStr)
            }
        }
    }
    
    //인증번호 다시 보내기
    func requestAgain() {
        print("재요청")
        guard let phoneNumber = UserDefaultsManager.shared.fetchValue(type: .phoneNumber) as? String else { return }
        FirebaseManager.shared.fetchVerificationId(phoneNumber: phoneNumber) { value in
            value ? print("인증코드 재요청 성공") : print("인증코드 재요청 실패")
        }
    }
    
    //MARK: 타임아웃 메서드 추가해야됨
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }

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
