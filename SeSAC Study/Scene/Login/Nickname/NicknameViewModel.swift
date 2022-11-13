//
//  NicknameViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

final class NickNameViewModel: CommonViewModel {
    
    struct Input {
        let nickNameText: ControlProperty<String?>
        let tapDoneButton: ControlEvent<Void>
    }
    struct Output {
        let validNicknameCount: Observable<Bool>
        let longNickname: Observable<Bool>
        let buttonStatus: Driver<ButtonStatus>
        let tapDoneButton: ControlEvent<Void>
        let enableNickname: Driver<NicknameCheck>
    }
    func transform(input: Input) -> Output {
        let validNickNameCount = input.nickNameText.orEmpty
            .map { $0.count >= 1 && $0.count <= 10 }
            .share()
        let longNickname = input.nickNameText.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .map { $0.count > 10 }
            .share()
        let buttonStatus = buttonStatus.asDriver(onErrorJustReturn: .disable)
        let enableNickname = isEnable.asDriver(onErrorJustReturn: .fail)
        
        return Output(validNicknameCount: validNickNameCount, longNickname: longNickname, buttonStatus: buttonStatus, tapDoneButton: input.tapDoneButton, enableNickname: enableNickname)
    }
    
    var buttonStatus = BehaviorRelay<ButtonStatus>(value: .disable)
    
    var isEnable = PublishRelay<NicknameCheck>()
    
    func setButtonStatus(value: ButtonStatus) {
        buttonStatus.accept(value)
    }
    
    func checkIsEnable() {
        buttonStatus.value == .enable ? isEnable.accept(.success) : isEnable.accept(.lengthFail)
    }
    
    func setNickname(name: String) {
        UserDefaultsManager.shared.setValue(value: name, type: .nick)
    }
    
    func checkInvalid() -> Bool {
        guard let invalidStatus = UserDefaultsManager.shared.fetchValue(type: .invalidNickname) as? Bool else { print("뭘까")
            return false }
        print(invalidStatus)
        return invalidStatus
    }
    
    func setInvalid() {
        UserDefaultsManager.shared.setValue(value: false, type: .invalidNickname)
    }
    
    func checkUserDefaultsExist() -> Bool {
        
        let nickname = UserDefaultsManager.shared.fetchValue(type: .nick) as? String ?? ""
        return nickname.isEmpty ? false : true
    }
    
    func fetchNickname() -> String {
        return UserDefaultsManager.shared.fetchValue(type: .nick) as? String ?? ""
    }
}
