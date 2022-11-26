//
//  AroundSesacViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/25.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

final class AroundSesacViewModel {
    var sesacList = BehaviorRelay<[FromQueueDB]>(value: [])

    func startSeSacSearch() {
        
        let lat = Location.lat.value
        let long = Location.long.value
        print("(&ㅕ)$(#*& 가져온 위치 \(lat) \(long)")
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
    
    func studyRequest(uid: String) {
        let api = SeSacAPI.studyRequest(otherUid: uid)
        
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = StudyRequestError(rawValue: statusCode) else {
                print("에러 못가져왔어요 스터디리퀘스트")
                return
            }
            print(statusCode)
        }
    }
    
    func checkReviewEmpty(reviews: [String]) -> Bool {
        return reviews.isEmpty ? true : false
    }
    func checkListEmpty(list: [FromQueueDB]) -> Bool {
        return list.isEmpty ? true : false
    }
}
