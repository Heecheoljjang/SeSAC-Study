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
    
    var searchList = BehaviorRelay<SesacSearch>(value: SesacSearch(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
    var aroundStudyList = BehaviorRelay<[String]>(value: [])
    var myStudyList = BehaviorRelay<[String]>(value: [])
    
    var currentLocation = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
    
    func fetchSeSacSearch(location: CLLocationCoordinate2D) {
        let api = SeSacAPI.queueSearch(lat: location.latitude, lon: location.longitude)

        APIService.shared.request(type: SesacSearch.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in

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
    
    func setStudyList(data: SesacSearch) {
        var list: [String] = []
        searchList.value.fromQueueDB.forEach {
            list.append(contentsOf: $0.studylist)
        }
        searchList.value.fromQueueDBRequested.forEach {
            list.append(contentsOf: $0.studylist)
        }
        aroundStudyList.accept(list.filter { !searchList.value.fromRecommend.contains($0) }.sorted(by: <))
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
}
