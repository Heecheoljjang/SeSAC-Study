//
//  NearUserViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/24.
//

import Foundation
import RxCocoa
import RxSwift

final class NearUserViewModel {
    
    var cancelStatus = PublishRelay<SesacCancelError>()
    
    func stopSesacSearch() {
        let api = SeSacAPI.stopQueueSearch
        
        APIService.shared.noResponseRequest(method: .delete, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = SesacCancelError(rawValue: statusCode) else {
                print("새싹찾기 중지 실패")
                return }
            switch status {
            case .tokenError:
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        print("아이디토큰받아왔으므로 네트워크 통신하기: \(token)")
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self?.cancelStatus.accept(.tokenError) //다시 눌러달라고 토스트띄우기. 재귀방지
                    case .failure(let error):
                        print("아이디토큰 못받아옴 \(error)")
                        LoadingIndicator.hideLoading()
                        self?.cancelStatus.accept(.clientError)
                    }
                }
            default:
                self?.cancelStatus.accept(status)
            }
        }
    }
}
