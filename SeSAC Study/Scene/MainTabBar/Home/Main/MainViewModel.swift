//
//  MainViewModel.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/13.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class MainViewModel {
    
    var searchList = PublishRelay<SesacSearch>()
    
    //나의 위치
    var currentLocation = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
    
    var currentStatus = BehaviorRelay<MatchingStatus>(value: .normal)
    
    //위치를 잘 가져오면 accept로 위치 넣어서 서버통신. 잘 못가져오면 새싹 위치 accept
    var selectedLocation = PublishRelay<CLLocationCoordinate2D>()
    
    var currentAuthStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
    
    func removeUserDefatuls() {
        UserDefaultsManager.shared.removeSomeValue()
    }
    
    func setCurrentLocation(location: CLLocationCoordinate2D) {
        currentLocation.accept(location)
    }
    
    func fetchSeSacSearch(location: CLLocationCoordinate2D) {
        let api = SeSacAPI.queueSearch(lat: location.latitude, lon: location.longitude)
        
//        APIService.shared.request(type: SesacSearch.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers, errorType: .SesacSearchError) { [weak self] result in
//            switch result {
//            case .success(let list):
//                print("통신 성공", list)
//                self?.searchList.accept(list)
//            case .failure(let error):
//                print("검색 에러남: \(error.localizedDescription)")
//            }
//        }
        APIService.shared.request(type: SesacSearch.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in
//            switch result {
//            case .success(let list):
//                print("통신 성공", list)
//                self?.searchList.accept(list)
//            case .failure(let error):
//                print("검색 에러남: \(error.localizedDescription)")
//            }
            guard let error = SesacSearchError(rawValue: statusCode) else { return }
            switch error {
            case .searchSuccess:
                guard let data = data else { return }
                print("통신성공: \(data)")
                self?.searchList.accept(data)
            default:
                print("검색에러: \(error)")
            }
        }
    }
    
    func fetchQueueState() {
        let api = SeSacAPI.myQueueState
        
//        APIService.shared.request(type: MyQueueState.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers, errorType: .QueueStateError) { [weak self] result in
//            switch result {
//            case .success(let state):
//                print("통신 성공", state)
//                switch state.matched {
//                case 0:
//                    self?.currentStatus.accept(.matching)
//                case 1:
//                    self?.currentStatus.accept(.matched)
//                default:
//                    self?.currentStatus.accept(.normal)
//                }
//            case .failure(let error):
//                print("검색 에러남: \(error.localizedDescription)")
//
//            }
//        }
        APIService.shared.request(type: MyQueueState.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in
            guard let error = QueueStateError(rawValue: statusCode) else { return }
            switch error {
            case .checkSuccess:
                guard let data = data else { return }
                print("통신 성공", data)
                switch data.matched {
                case 0:
                    self?.currentStatus.accept(.matching)
                case 1:
                    self?.currentStatus.accept(.matched)
                default:
                    self?.currentStatus.accept(.normal)
                }
            case .normalState:
                self?.currentStatus.accept(.normal)
            default:
                print("에러남: \(error)")
            }
        }
    }

    func fetchMatchingStatus() -> MatchingStatus {
        return currentStatus.value
    }
    
    func setCurrentAuthStatus(status: CLAuthorizationStatus) {
        currentAuthStatus.accept(status)
    }
    
    func checkAuthorizationStatus() -> CLAuthorizationStatus {
        return currentAuthStatus.value
    }
}
