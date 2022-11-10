//
//  GenderViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/10.
//

import Foundation
import RxCocoa
import RxSwift

final class GenderViewModel {
    
    var gender = PublishRelay<Gender>()
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: ButtonStatus.disable)
    
    var genderStatus = BehaviorRelay<GenderStatus>(value: .unselected)
    
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
        UserDefaultsManager.shared.setValue(value: gender.value, type: .gender)
    }
}
