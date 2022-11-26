//
//  ReceivedViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/26.
//

import Foundation
import RxCocoa
import RxSwift

final class ReceivedViewModel {
    var sesacList = BehaviorRelay<[FromQueueDB]>(value: [])
    var studyStatus = PublishRelay<StudyAcceptError>()

    func startSeSacSearch() {
        
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
                self?.sesacList.accept(data.fromQueueDBRequested)
            default:
                print("새싹 친구 검색에러: \(error)")
            }
        }
    }
    func studyAccept(uid: String) {
        let api = SeSacAPI.studyRequest(otherUid: uid)
        
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = StudyAcceptError(rawValue: statusCode) else {
                print("에러 못가져왔어요 스터디어셉트")
                return
            }
            self?.studyStatus.accept(status)
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
