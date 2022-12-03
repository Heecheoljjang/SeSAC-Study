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
    var requestStatus = PublishRelay<StudyRequestError>()
    var acceptStatus = PublishRelay<StudyAcceptError>()

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
    
    func studyRequest(uid: String) {
        let api = SeSacAPI.studyRequest(otherUid: uid)
        
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = StudyRequestError(rawValue: statusCode) else {
                print("에러 못가져왔어요 스터디리퀘스트")
                return
            }
            print("요청하기 상태코드 \(statusCode)")
            self?.requestStatus.accept(status)
        }
    }
    
    func studyAccept(uid: String) {
        print("========uid=========\n\(uid)\n=========================")
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
