//
//  GenderViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/10.
//

import Foundation
import RxCocoa
import RxSwift
import FirebaseAuth

final class GenderViewModel: CommonViewModel {
    
    struct Input {
        let tapDoneButton: ControlEvent<Void>
    }
    struct Output {
        let gender: Driver<Gender>
        let buttonStatus: Driver<ButtonStatus>
        let tapDoneButton: ControlEvent<Void>
        let genderStatus: Driver<GenderStatus>
        let errorStatus: Driver<LoginErrorString>
    }
    func transform(input: Input) -> Output {
        let gender = gender.asDriver(onErrorJustReturn: .man)
        let buttonStatus = buttonStatus.asDriver(onErrorJustReturn: .disable)
        let genderStatus = genderStatus.asDriver(onErrorJustReturn: .unselected)
        let errorStatus = errorStatus.asDriver(onErrorJustReturn: .clientError)
        
        return Output(gender: gender, buttonStatus: buttonStatus, tapDoneButton: input.tapDoneButton, genderStatus: genderStatus, errorStatus: errorStatus)
    }
    
    var gender = PublishRelay<Gender>()
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
    
    var genderStatus = BehaviorRelay<GenderStatus>(value: .unselected)
    
    var errorStatus = PublishRelay<LoginErrorString>()
    
    func setGenderMan() {
        gender.accept(Gender.man)
    }
    
    func setGenderWoman() {
        gender.accept(Gender.woman)
    }
    
    func setButtonEnable() {
        buttonStatus.accept(.enable)
    }
    
    func checkStatus() {
        buttonStatus.value == .enable ? genderStatus.accept(.selected) : genderStatus.accept(.unselected)
    }
    
    func setGender(gender: Gender) {
        UserDefaultsManager.shared.setValue(value: "\(gender.value)", type: .gender)
    }
    
    func requestSignUp() {
        
        guard let phoneNumber = UserDefaultsManager.shared.fetchValue(type: .phoneNumber) as? String,
              let fcmToken = UserDefaultsManager.shared.fetchValue(type: .fcmToken) as? String,
              let nickname = UserDefaultsManager.shared.fetchValue(type: .nick) as? String,
              let birth = UserDefaultsManager.shared.fetchValue(type: .birth) as? String,
              let email = UserDefaultsManager.shared.fetchValue(type: .email) as? String,
              let gender = UserDefaultsManager.shared.fetchValue(type: .gender) as? String else {
                  print("닐이 있음")
                  return }
        
        print(phoneNumber)
        print(fcmToken)
        print(nickname)
        print(birth)
        print(email)
        print(Int(gender)!)
        
        let api = SeSacAPI.signUp(phoneNumber: phoneNumber, fcmToken: fcmToken, nickname: nickname, birth: birth, email: email, gender: Int(gender)!)
        
        APIService.shared.request(type: SignUp.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers, errorType: .LoginError) { result in
            switch result {
            case .success(let data):
                LoadingIndicator.hideLoading()
                print("회원가입 성공!, data: \(data)")
                self.errorStatus.accept(.signUpSuccess)
            case .failure(let error):
                print("회원가입 실패")
                print(error.localizedDescription)
                let errorStr = error.fetchNetworkErrorString()
                print(errorStr)
                self.errorStatus.accept(errorStr)
            }
        }
    }
    
    func fetchIdToken() {
        FirebaseManager.shared.fetchIdToken { result in
            switch result {
            case .success(_):
                self.requestSignUp()
            case .failure(let error):
                LoadingIndicator.hideLoading()
                print("요청 만료돼서 다시 신청했는데 아이디토큰 받아오는거 실패함 \(error)")
                return
            }
        }
    }

    func setInvalidNickname(value: Bool) {
        UserDefaultsManager.shared.setValue(value: value, type: .invalidNickname)
    }
    
    func checkUserDefaultsExist() {
        guard let genderString = UserDefaultsManager.shared.fetchValue(type: .gender) as? String, let gender = Int(genderString) else { return }
        
        gender == 1 ? self.gender.accept(.man) : self.gender.accept(.woman)
    }
}
