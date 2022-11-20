//
//  InfoViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import Foundation
import RxSwift
import RxCocoa

final class InfoViewModel {
    
    var nickName = BehaviorRelay<String>(value: "")
    
    func setNickName() {
        let name = UserDefaultsManager.shared.fetchValue(type: .nick) as? String ?? ""
        print("내 이름은", name)
        self.nickName.accept(name)
    }
}
