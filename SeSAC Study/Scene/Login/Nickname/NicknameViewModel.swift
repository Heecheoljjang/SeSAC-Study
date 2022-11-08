//
//  NicknameViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

final class NickNameViewModel {
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: .disable)
    
    var isEnable = BehaviorRelay<NicknameCheck>(value: .lengthFail)
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }
    
    func checkIsEnable() {
        buttonStatus.value == .enable ? isEnable.accept(.success) : isEnable.accept(.lengthFail)
    }
}
