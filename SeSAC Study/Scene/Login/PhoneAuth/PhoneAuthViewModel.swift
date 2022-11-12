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
    
    var phoneNumberCheck = PublishRelay<AuthCheck>()
    
    func checkAuth(code: String) {
        guard let id = UserDefaultsManager.shared.fetchValue(type: .verificationId) as? String else { return }
        
        if buttonStatus.value == ButtonStatus.disable {
            authCodeCheck.accept(.wrongCode)
            return
        }
        LoadingIndicator.showLoading()
        FirebaseManager.shared.checkAuthCode(verId: id, authCode: code) { [weak self] result in
            switch result {
            case .timeOut:
                LoadingIndicator.hideLoading()
                self?.authCodeCheck.accept(.timeOut)
            case .wrongCode:
                LoadingIndicator.hideLoading()
                self?.authCodeCheck.accept(.wrongCode)
            case .fail:
                LoadingIndicator.hideLoading()
                self?.authCodeCheck.accept(.fail)
            case .success:
                self?.authCodeCheck.accept(.success)
            }
        }
    }
    
    func fetchIdToken() {
        FirebaseManager.shared.fetchIdToken { result in
            switch result {
            case .success(let token):
                print("아이디토큰받아왔으므로 네트워크 통신하기: \(token)")
                self.checkUser()
            case .failure(let error):
                print("아이디토큰 못받아옴 \(error)")
                LoadingIndicator.hideLoading()
                return
            }
        }
    }
    
    private func checkUser() {
        let api = SeSacAPI.signIn
        APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { result in
            switch result {
            case .success(let response):
                print("성공했지요: \(response)")
                LoadingIndicator.hideLoading()
                self.errorStatus.accept(.signUpSuccess)
            case .failure(let error):
                print("여기 실패입니다 \(error)")
                LoadingIndicator.hideLoading()
                let errorStr = error.fetchNetworkErrorString()
                self.errorStatus.accept(errorStr)
            }
        }
    }
    
    //인증번호 다시 보내기
    func requestAgain() {
        print("재요청")
        LoadingIndicator.showLoading()
        guard let phoneNumber = UserDefaultsManager.shared.fetchValue(type: .phoneNumber) as? String else { return }
        FirebaseManager.shared.fetchVerificationId(phoneNumber: phoneNumber) { [weak self] value in
            switch value {
            case .wrongNumber:
                LoadingIndicator.hideLoading()
                self?.phoneNumberCheck.accept(.wrongNumber)
            case .fail:
                LoadingIndicator.hideLoading()
                self?.phoneNumberCheck.accept(.fail)
            case .manyRequest:
                LoadingIndicator.hideLoading()
                self?.phoneNumberCheck.accept(.manyRequest)
            case .success:
                LoadingIndicator.hideLoading()
                self?.phoneNumberCheck.accept(.success)
            }
        }
    }
    
    //MARK: 타임아웃 메서드 추가해야됨
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }

    func setErrorStatus(status: NetworkErrorString) {
        errorStatus.accept(status)
    }
}
