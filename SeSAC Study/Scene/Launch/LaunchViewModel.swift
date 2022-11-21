//
//  LaunchViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/12.
//

import Foundation
import RxCocoa
import RxSwift

final class LaunchViewModel: CommonViewModel {
    
    struct Input {}
    struct Output {
        let idTokenIsEmpty: Driver<Bool>
        let status: Driver<LoginError>
    }
    func transform(input: Input) -> Output {
        let isEmpty = idTokenIsEmpty.asDriver(onErrorJustReturn: false)
        let status = status.asDriver(onErrorJustReturn: .clientError)
        return Output(idTokenIsEmpty: isEmpty, status: status)
    }
    
    var idTokenIsEmpty = PublishRelay<Bool>()
    var status = PublishRelay<LoginError>()
    
    func checkIdToken() {
        print("아이디토큰: \(UserDefaultsManager.shared.fetchValue(type: .idToken) as? String)")
        idTokenIsEmpty.accept(UserDefaultsManager.shared.checkIdTokenIsEmpty())
    }
    
    func setLocationAuth() {
        UserDefaultsManager.shared.setValue(value: LocationAuthStatus.restriced.rawValue, type: .locationAuth) //0으로 세팅
    }

    func checkUserStatus() {
        let api = SeSacAPI.signIn
        
        APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { _, statusCode in
            guard let status = LoginError(rawValue: statusCode) else { return }
            self.status.accept(status)
        }
    }
    
    func setStatus(status: LoginError) {
        self.status.accept(status)
    }
}
