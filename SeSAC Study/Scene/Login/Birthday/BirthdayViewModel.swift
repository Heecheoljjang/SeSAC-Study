//
//  BirthdayViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel {
    
    var birthday = PublishRelay<Date>()
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
    
    var checkStatus = PublishRelay<BirthdayStatus>()
    
    func setBirthday(date: Date) {
        birthday.accept(date)
    }
    
    //만 17세 이상이면 buttonStatus able로
    func checkAge(date: Date) {
        return date.compareYear() ? buttonStatus.accept(ButtonStatus.enable) : buttonStatus.accept(ButtonStatus.disable)
    }
    
    func setCheckStatus() {
        buttonStatus.value == .enable ? checkStatus.accept(.enable) : checkStatus.accept(.disable)
    }
    
    func setBirth(date: Date) {
        let dateString = date.dateToString(type: .dateString)
        UserDefaultsManager.shared.setValue(value: dateString, type: .birth)
    }
}
