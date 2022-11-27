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
    var acceptStatus = PublishRelay<StudyAcceptError>()
    var myQueueStatus = PublishRelay<MyQueueState>()

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
            self?.acceptStatus.accept(status)
            print(statusCode)
        }
    }
    
    func fetchMyQueueState() {
        print("queuestate 실행됨")
        let api = SeSacAPI.myQueueState

        APIService.shared.request(type: MyQueueState.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in
            print("queueState 상태코드 \(statusCode)")
            guard let error = QueueStateError(rawValue: statusCode) else {
                print("에러떠서 queuestate못가져옴")
                return }
            switch error {
            case .checkSuccess, .normalState:
                guard let data = data else {
                    print("Queuestate통신 데이터 못가져옴")
                    return }
                print("상태 통신 성공", data, error)
                self?.myQueueStatus.accept(data)
            default:
                print("노필요")
            }
        }
    }
    
    func setOtherUid(uid: String) {
        UserDefaultsManager.shared.setValue(value: uid, type: .otherUid)
    }
    
    func checkReviewEmpty(reviews: [String]) -> Bool {
        return reviews.isEmpty ? true : false
    }
    func checkListEmpty(list: [FromQueueDB]) -> Bool {
        return list.isEmpty ? true : false
    }
}
