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
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let nickNameText: ControlProperty<String?>
        let tapDoneButton: ControlEvent<Void>
    }
    struct Output {
        let validNicknameCount: Void
        let longNickname: Observable<Bool>
        let buttonStatus: Driver<ButtonStatus>
        let tapDoneButton: Void
        let enableNickname: Driver<NicknameCheck>
    }
    func transform(input: Input) -> Output {
        let validNickNameCount: Void = input.nickNameText.orEmpty
            .map { $0.count >= 1 && $0.count <= 10 }
            .share().bind(onNext: { [weak self] value in
                value ? self?.setButtonStatus(value: ButtonStatus.enable) : self?.setButtonStatus(value: ButtonStatus.disable)
            })
            .disposed(by: disposeBag)
        let longNickname = input.nickNameText.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .map { $0.count > 10 }
            .share()
        let buttonStatus = buttonStatus.asDriver(onErrorJustReturn: .disable)
        let enableNickname = isEnable.asDriver(onErrorJustReturn: .fail)
        let tapDoneButton: Void = input.tapDoneButton.bind(onNext: { [weak self] _ in
            self?.checkIsEnable()
        })
        .disposed(by: disposeBag)
        
        return Output(validNicknameCount: validNickNameCount, longNickname: longNickname, buttonStatus: buttonStatus, tapDoneButton: tapDoneButton, enableNickname: enableNickname)
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

    func removeAllUserDefaults() {
        UserDefaultsManager.shared.removeSomeValue()
    }
    
    func checkUserDefaultsExist() -> Bool {
        
        let nickname = UserDefaultsManager.shared.fetchValue(type: .nick) as? String ?? ""
        return nickname.isEmpty ? false : true
    }
    
    func fetchNickname() -> String {
        return UserDefaultsManager.shared.fetchValue(type: .nick) as? String ?? ""
    }
}
