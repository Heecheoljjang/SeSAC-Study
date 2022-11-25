//
//  NearUserViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/24.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

final class NearUserViewModel {
    
    var cancelStatus = PublishRelay<SesacCancelError>()
    var sesacList = BehaviorRelay<[FromQueueDB]>(value: [])
    
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

    func startSesacSearch() {
        let lat = Location.lat.value
        let long = Location.long.value
        let api = SeSacAPI.queueSearch(lat: lat, lon: long)

        APIService.shared.request(type: AroundSesacSearch.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in
            print(statusCode)
            guard let error = SesacSearchError(rawValue: statusCode) else {
                print("실패했음 도대체 왜")
                return }
            switch error {
            case .searchSuccess:
                guard let data = data else {
                    print("데이터 못가져왔따")
                    return }
                print("새싹친구 통신성공: \(data)")
                self?.sesacList.accept(data.fromQueueDB)
            default:
                print("새싹 친구 검색에러: \(error)")
            }
        }
    }
    
    func checkListEmpty(list: [FromQueueDB]) -> Bool {
        return list.isEmpty ? true : false
    }
}
