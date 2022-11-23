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
        idTokenIsEmpty.accept(UserDefaultsManager.shared.checkIdTokenIsEmpty())
    }
    
    func setLocationAuth() {
        UserDefaultsManager.shared.setValue(value: LocationAuthStatus.restriced.rawValue, type: .locationAuth) //0으로 세팅
    }

    func checkUserStatus() {
        let api = SeSacAPI.signIn
        
        APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { _, statusCode in
            guard let status = LoginError(rawValue: statusCode) else { return }
            switch status {
            case .tokenError:
                //토큰갱신
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self.checkIdToken()
                    case .failure(_):
                        self.status.accept(.clientError)
                        LoadingIndicator.hideLoading()
                        return
                    }
                }
            default:
                self.status.accept(status)
            }
        }
    }
    
    func setStatus(status: LoginError) {
        self.status.accept(status)
    }
}
