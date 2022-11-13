//
//  EmailViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailViewModel: CommonViewModel {
    
    struct Input {
        let emailText: ControlProperty<String?>
        let doneButtonTap: ControlEvent<Void>
    }
    struct Output {
        let emailText: ControlProperty<String>
        let buttonStatus: Driver<ButtonStatus>
        let doneButtonTap: ControlEvent<Void>
        let emailStatus: Driver<EmailStatus>
    }
    func transform(input: Input) -> Output {
        let emailText = input.emailText.orEmpty
        let buttonStatus = buttonStatus.asDriver(onErrorJustReturn: .disable)
        let emailStatus = emailStatus.asDriver(onErrorJustReturn: .invalid)
        
        return Output(emailText: emailText, buttonStatus: buttonStatus, doneButtonTap: input.doneButtonTap, emailStatus: emailStatus)
    }
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: .disable)
    
    var emailStatus = BehaviorRelay<EmailStatus>(value: .invalid)
    
    func checkEmail(email: String) {
        let regexStr = "^[0-9a-zA-Z]+@[a-zA-Z]+\\.[a-z.]{1,6}$"
        email.range(of: regexStr, options: .regularExpression) != nil ? buttonStatus.accept(.enable) : buttonStatus.accept(.disable)
    }
    
    func setEmailStatus() {
        buttonStatus.value == .enable ? emailStatus.accept(.valid) : emailStatus.accept(.invalid)
    }
    
    func setEmail(email: String) {
        UserDefaultsManager.shared.setValue(value: email, type: .email)
    }
    
    func checkUserDefaultsExist() -> Bool {
        //nil이면 false
//        guard let email = UserDefaultsManager.shared.fetchValue(type: .email) as? String else { return false }
//        print("제발요 \(email)")
        let email = UserDefaultsManager.shared.fetchValue(type: .email) as? String ?? ""
        return email.isEmpty ? false : true
    }
    
    func fetchEmail() -> String {
        guard let email = UserDefaultsManager.shared.fetchValue(type: .email) as? String else { print("이메일 없음 ")
            return "" }
        print("닐 아님", email)
        return email
    }
}
