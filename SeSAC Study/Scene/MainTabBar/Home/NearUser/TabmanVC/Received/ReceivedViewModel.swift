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
            case .tokenError:
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        print("아이디토큰받아왔으므로 네트워크 통신하기: \(token)")
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self?.startSeSacSearch()
                    case .failure(let error):
                        print("아이디토큰 못받아옴 \(error)")
                        self?.sesacList.accept([])
                    }
                }
            default:
                print("새싹 친구 검색에러: \(error)")
            }
        }
    }
    func studyAccept(uid: String) {
        let api = SeSacAPI.studyAccept(otherUid: uid)
        
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = StudyAcceptError(rawValue: statusCode) else {
                print("에러 못가져왔어요 스터디어셉트")
                return
            }
            print("gklsdgjdlskafj \(statusCode)")
            self?.acceptStatus.accept(status)
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
