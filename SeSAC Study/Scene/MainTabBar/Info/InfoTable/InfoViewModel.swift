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
    
    var userInfo = PublishRelay<SignIn?>()
    var currentStatus = PublishRelay<LoginError>()
    //MARK: 저장된 유저디폴트값 가져오기
    func fetchUserInfo() {
        print("데이터가져올래")
        guard let data = UserDefaultsManager.shared.fetchValue(type: .userInfo) as? SignIn else { return }
        print("내 데이터 \(data)")
        userInfo.accept(data)
    }
    
    func checkUser() {
        let api = SeSacAPI.signIn
        APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { data, statusCode in
            guard let status = LoginError(rawValue: statusCode) else { return }
            guard let data = data else { return }
            print("인포쪽 \(statusCode) \(data)")
            switch status {
            case .signUpSuccess:
                print("성공적이죠?")
                UserDefaultsManager.shared.setValue(value: data, type: .userInfo)
                self.currentStatus.accept(status)
            default:
                print("실패6548948")
                self.currentStatus.accept(.clientError)
            }
        }
    }
}
