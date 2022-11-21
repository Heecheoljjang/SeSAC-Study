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

final class PhoneNumberViewModel: CommonViewModel {
    
    struct Input {
        let numberText: ControlProperty<String?>
        let tapDoneButton: ControlEvent<Void>
    }
    struct Output {
        let numberText: ControlProperty<String>
        let phoneNumber: Driver<String>
        let buttonStatus: Driver<ButtonStatus>
        let tapDoneButton: ControlEvent<Void>
        let sendAuthCheck: Driver<AuthCheck>
    }
    func transform(input: Input) -> Output {
        let numberText = input.numberText.orEmpty
        let phoneNumber = phoneNumber.asDriver(onErrorJustReturn: "")
        let buttonStatus = buttonStatus.asDriver(onErrorJustReturn: .disable)
        let sendAuthCheck = sendAuthCheck.asDriver(onErrorJustReturn: .fail)
        
        return Output(numberText: numberText, phoneNumber: phoneNumber, buttonStatus: buttonStatus, tapDoneButton: input.tapDoneButton, sendAuthCheck: sendAuthCheck)
    }
    
    var sendAuthCheck = PublishRelay<AuthCheck>()

    var phoneNumber = BehaviorRelay<String>(value: "")
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
        
    func sendPhoneAuth() {
        
        if buttonStatus.value == ButtonStatus.disable {
            sendAuthCheck.accept(AuthCheck.wrongNumber)
            return
        }
        LoadingIndicator.showLoading()
        let phoneNumber = phoneNumber.value.changeFormat()
        FirebaseManager.shared.fetchVerificationId(phoneNumber: phoneNumber) { [weak self] value in
            switch value {
            case .wrongNumber:
                LoadingIndicator.hideLoading()
                self?.sendAuthCheck.accept(.wrongNumber)
            case .fail:
                LoadingIndicator.hideLoading()
                self?.sendAuthCheck.accept(.fail)
            case .manyRequest:
                LoadingIndicator.hideLoading()
                self?.sendAuthCheck.accept(.manyRequest)
            case .success:
                LoadingIndicator.hideLoading()
                self?.sendAuthCheck.accept(.success)
            }
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
        let number = value.replacingOccurrences(of: "-", with: "")
        UserDefaultsManager.shared.setValue(value: number.changeFormat(), type: .phoneNumber)
    }    
    func removeUserDefaults() {
        UserDefaultsManager.shared.removeSomeValue()
    }
}
