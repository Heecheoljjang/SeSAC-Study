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

final class PhoneAuthViewModel: CommonViewModel {
        
    struct Input {
        let authCode: ControlProperty<String?>
        let tapDoneButton: ControlEvent<Void>
        let tapRetryButton: ControlEvent<Void>
    }
    struct Output {
        let authCode: Observable<Bool>
        let buttonStatus: Driver<ButtonStatus>
        let tapDoneButton: ControlEvent<Void>
        let authCodeCheck: Driver<AuthCodeCheck>
//        let errorStatus: Driver<LoginErrorString>
        let errorStatus: Driver<LoginError>
        let tapRetryButton: ControlEvent<Void>
        let phoneNumberCheck: Driver<AuthCheck>
    }
    func transform(input: Input) -> Output {
        let authCode = input.authCode.orEmpty.map{$0.count == 6}
        let buttonStatus = buttonStatus.asDriver(onErrorJustReturn: .disable)
        let authCodeCheck = authCodeCheck.asDriver(onErrorJustReturn: .fail)
        let errorStatus = errorStatus.asDriver(onErrorJustReturn: .clientError)
        let phoneNumberCheck = phoneNumberCheck.asDriver(onErrorJustReturn: .fail)
        
        return Output(authCode: authCode, buttonStatus: buttonStatus, tapDoneButton: input.tapDoneButton, authCodeCheck: authCodeCheck, errorStatus: errorStatus, tapRetryButton: input.tapRetryButton, phoneNumberCheck: phoneNumberCheck)
    }
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
        
    var authCodeCheck = PublishRelay<AuthCodeCheck>()
    
//    var errorStatus = PublishRelay<LoginErrorString>()
    var errorStatus = PublishRelay<LoginError>()
    
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
                UserDefaultsManager.shared.setValue(value: token, type: .idToken)
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

        APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { (data, statusCode) in
            guard let statusCode = LoginError(rawValue: statusCode) else { return }
            switch statusCode {
            case .signUpSuccess:
                guard let data = data else { return }
                print("성공했지요 상태코드: \(statusCode)")
                print("데이터: \(data)")
                //유저디폴트에 다시 저장해야함
                self.setUserDefaults(data: data)
                LoadingIndicator.hideLoading()
                self.errorStatus.accept(.signUpSuccess)
            default :
                print("에러에러 상태코드: \(statusCode.rawValue)")
                LoadingIndicator.hideLoading()
                self.errorStatus.accept(statusCode)
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
    
    private func setUserDefaults(data: SignIn) {
        //핸드폰번호, 닉네임, 생일, 이메일, 성별, fcm토큰
        UserDefaultsManager.shared.setValue(value: data.phoneNumber, type: .phoneNumber)
        UserDefaultsManager.shared.setValue(value: data.nick, type: .nick)
        UserDefaultsManager.shared.setValue(value: data.birth, type: .birth)
        UserDefaultsManager.shared.setValue(value: data.email, type: .email)
        UserDefaultsManager.shared.setValue(value: data.gender, type: .gender)
        UserDefaultsManager.shared.setValue(value: data.fcMtoken, type: .fcmToken)
        
        //MARK: 데이터 전체 저장
        UserDefaultsManager.shared.setValue(value: data, type: .userInfo)
    }
    
    //MARK: 타임아웃 메서드 추가해야됨
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }
}
