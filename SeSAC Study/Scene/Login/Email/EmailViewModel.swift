//
//  EmailViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailViewModel {
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: .disable)
    
    var emailStatus = BehaviorRelay<EmailStatus>(value: .invalid)
    
    func checkEmail(email: String) {
        let regexStr = "^[0-9a-zA-Z]+@[a-zA-Z]+\\.[a-z.]{1,6}$"
        email.range(of: regexStr, options: .regularExpression) != nil ? buttonStatus.accept(.enable) : buttonStatus.accept(.disable)
    }
    
    func setEmailStatus() {
        buttonStatus.value == .enable ? emailStatus.accept(.valid) : emailStatus.accept(.invalid)
    }
}
