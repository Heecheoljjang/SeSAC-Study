//
//  HobbyViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/19.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

final class HobbyViewModel {
    
    var searchList = BehaviorRelay<AroundSesacSearch>(value: AroundSesacSearch(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
    var aroundStudyList = BehaviorRelay<[String]>(value: [])
    var myStudyList = BehaviorRelay<[String]>(value: [])
    var searchStatus = PublishRelay<SesacRequestError>()
    
    func fetchSesacSearch() {
        let lat = Location.lat.value
        let long = Location.long.value
        print("가져온 위치 \(lat) \(long)")
        let api = SeSacAPI.queueSearch(lat: lat, lon: long)

        APIService.shared.request(type: AroundSesacSearch.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in

            guard let error = SesacSearchError(rawValue: statusCode) else { return }
            switch error {
            case .searchSuccess:
                guard let data = data else { return }
                print("새싹친구 통신성공: \(data)")
                self?.searchList.accept(data)
            default:
                print("새싹 친구 검색에러: \(error)")
            }
        }
    }
    
    func tapSearchButton() {
        let lat = Location.lat.value
        let long = Location.long.value

        print("유저디뽈트에서 가져온 위치", lat, long)
        let studyList = myStudyList.value.count == 0 ? ["anything"] : myStudyList.value
        let api = SeSacAPI.queue(lat: lat, lon: long, studyList: studyList)
        APIService.shared.noResponseRequest(method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] statusCode in
            guard let status = SesacRequestError(rawValue: statusCode) else { return }
            print("서치버튼상태 \(status), \(statusCode)")
            switch status {
            case .tokenError:
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        print("아이디토큰받아왔으므로 네트워크 통신하기: \(token)")
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self?.searchStatus.accept(.tokenError) //다시 눌러달라고 토스트띄우기. 재귀방지
                    case .failure(let error):
                        print("아이디토큰 못받아옴 \(error)")
                        LoadingIndicator.hideLoading()
                        self?.searchStatus.accept(.clientError)
                    }
                }
            default:
                self?.searchStatus.accept(status)
            }
        }
    }
    
    func setStudyList(data: AroundSesacSearch) {
        var list: [String] = []
        searchList.value.fromQueueDB.forEach {
            list.append(contentsOf: $0.studylist)
        }
        searchList.value.fromQueueDBRequested.forEach {
            list.append(contentsOf: $0.studylist)
        }
        list = list.filter { !searchList.value.fromRecommend.contains($0) } //추천리스트와 동일한거 제거
                    .filter { !$0.isEmpty }
        list = Array(Set(list))
        for i in 0..<list.count {
            if list[i] == "anything" {
                list[i] = "아무거나"
                break
            }
        }
        aroundStudyList.accept(list.sorted(by: <))
    }
    
    func appendMyStudyList(list: [String]) {
        var temp = myStudyList.value
        temp.append(contentsOf: list)
        myStudyList.accept(temp)
    }
    
    func appendMyStudyListElement(study: String) {
        var temp = myStudyList.value
        temp.append(study)
        myStudyList.accept(temp)
    }
    
    func checkAlreadyExist(list: [String]) -> Bool {
        let currentStudyList = myStudyList.value
        for i in list {
            if currentStudyList.contains(i) {
                return true
            }
        }
        return false
    }
    
    func checkElementExist(study: String) -> Bool {
        return myStudyList.value.contains(study) ? true : false
    }
    
    func checkTextCount(list: [String]) -> Bool {
        for i in list {
            if i.count > 8 {
                return true
            }
        }
        return false
    }
    
    func checkOnlyEmpty(list: [String]) -> Bool {
        return list.filter { !$0.isEmpty }.count == 0 ? true : false
    }
    
    func createStringArray(text: String) -> [String] {
        //공백기준으로 나눔 -> 앞뒤 공백 제거(trim) -> set으로 중복체크 -> 다시 array로
        var temp: [String] = []
        text.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ")
            .forEach {
                temp.append($0.trimmingCharacters(in: .whitespaces))
            }
        temp = Array(Set(temp.filter { !$0.isEmpty })).sorted(by: <)
        return temp
    }
    
    func checkMyStudyListCount(list: [String]) -> Bool {
        let currentCount = myStudyList.value.count
        return currentCount + list.count > 8 ? true : false
    }
    func checkMyStudyListCountAlready() -> Bool {
        return myStudyList.value.count == 8 ? true : false
    }
    
    func removeMyStudyListElement(item: Int) {
        var temp = myStudyList.value
        let study = temp[item]
        temp = temp.filter { $0 != study }
        myStudyList.accept(temp)
    }
    
    func fetchRecommendListCount() -> Int {
        return searchList.value.fromRecommend.count
    }
    func fetchRecommendListData(item: Int) -> String {
        return searchList.value.fromRecommend[item]
    }
    
    func fetchSesacStudyListCount() -> Int {
        return aroundStudyList.value.count
    }
    func fetchSesacStudyListData(item: Int) -> String {
        return aroundStudyList.value[item]
    }

    func fetchMyStudyListCount() -> Int {
        return myStudyList.value.count
    }
    func fetchMyStudyListData(item: Int) -> String {
        return myStudyList.value[item]
    }
    
//    func testFetchQueueState() {
//        print("queuestate 실행됨")
//        let api = SeSacAPI.myQueueState
//
//        APIService.shared.request(type: MyQueueState.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in
//            print("queueState 상태코드 \(statusCode)")
//            guard let error = QueueStateError(rawValue: statusCode) else {
//                print("에러떠서 queuestate못가져옴")
//                return }
//            switch error {
//            case .checkSuccess:
//                guard let data = data, let uid = data.matchedUid else {
//                    print("Queuestate통신 데이터 못가져옴")
//                    return }
//
//                UserDefaultsManager.shared.setValue(value: uid, type: .otherUid)
//                print("유아이디 저장완료 \(UserDefaultsManager.shared.fetchValue(type: .otherUid) as! String)")
//                print("상태 통신 성공", data, error)
//
//            case .normalState:
//                print("====\(data)=== \(error)")
//                self?.currentStatus.accept(.normal)
//            default:
//                print("상태 에러남: \(error)")
//            }
//        }
//    }
}
