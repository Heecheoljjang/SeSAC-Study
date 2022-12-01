//
//  BirthdayViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel: CommonViewModel {
    
    struct Input {
        let date: ControlProperty<Date>
        let tapDoneButton: ControlEvent<Void>
    }
    struct Output {
        let selectedDate: ControlProperty<Date>
        let birthday: Driver<Date>
        let buttonStatus: Driver<ButtonStatus>
        let tapDoneButton: ControlEvent<Void>
        let checkStatus: Driver<BirthdayStatus>
    }
    func transform(input: Input) -> Output {
        let birthday = birthday.asDriver(onErrorJustReturn: Date())
        let buttonStatus = buttonStatus.asDriver(onErrorJustReturn: .disable)
        let checkStatus = checkStatus.asDriver(onErrorJustReturn: .disable)
        
        return Output(selectedDate: input.date, birthday: birthday, buttonStatus: buttonStatus, tapDoneButton: input.tapDoneButton, checkStatus: checkStatus)
    }
    
    var birthday = PublishRelay<Date>()
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
    
    var checkStatus = PublishRelay<BirthdayStatus>()
    
    func setBirthday(date: Date) {
        birthday.accept(date)
    }
    
    func checkAge(date: Date) {
        return date.compareYear() ? buttonStatus.accept(ButtonStatus.enable) : buttonStatus.accept(ButtonStatus.disable)
    }
    
    func setCheckStatus() {
        buttonStatus.value == .enable ? checkStatus.accept(.enable) : checkStatus.accept(.disable)
    }
    
    func setBirth(date: Date) {
        let dateString = DateFormatterHelper.shared.dateToString(date: date, type: .dateString)
        UserDefaultsManager.shared.setValue(value: dateString, type: .birth)
    }

    func checkUserDefaultsExist() -> Bool {
        
        let birth = UserDefaultsManager.shared.fetchValue(type: .birth) as? String ?? ""
        
        return birth.isEmpty ? false : true

    }

    func fetchBirth() -> Date {
        guard let birth = UserDefaultsManager.shared.fetchValue(type: .birth) as? String else { return Date() }
        return DateFormatterHelper.shared.stringToDate(string: birth, type: .dateString)
    }
}
