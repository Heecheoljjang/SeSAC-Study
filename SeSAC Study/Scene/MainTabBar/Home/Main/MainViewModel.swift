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
import MapKit

final class MainViewModel {
    
    var searchList = PublishRelay<AroundSesacSearch>()
    
    //나의 위치
    var currentLocation = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
    
    var currentStatus = BehaviorRelay<MatchingStatus>(value: .normal)
    
    //위치를 잘 가져오면 accept로 위치 넣어서 서버통신. 잘 못가져오면 새싹 위치 accept
    var selectedLocation = PublishRelay<CLLocationCoordinate2D>()
    
    var currentAuthStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
    
//    func removeUserDefatuls() {
//        UserDefaultsManager.shared.removeSomeValue()
//    }
    
    func setCurrentLocation(location: CLLocationCoordinate2D) {
        currentLocation.accept(location)
    }
    
    func fetchSeSacSearch(location: CLLocationCoordinate2D) {
        let api = SeSacAPI.queueSearch(lat: location.latitude, lon: location.longitude)

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
    
    func fetchQueueState() {
        let api = SeSacAPI.myQueueState

        APIService.shared.request(type: MyQueueState.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in
            guard let error = QueueStateError(rawValue: statusCode) else { return }
            switch error {
            case .checkSuccess:
                guard let data = data else { return }
                print("상태 통신 성공", data, error)
                switch data.matched {
                case 0:
                    self?.currentStatus.accept(.matching)
                case 1:
                    self?.currentStatus.accept(.matched)
                default:
                    self?.currentStatus.accept(.normal)
                }
            case .normalState:
                print("====\(data)=== \(error)")
                self?.currentStatus.accept(.normal)
            default:
                print("상태 에러남: \(error)")
            }
        }
    }

    func fetchMatchingStatus() -> MatchingStatus {
        return currentStatus.value
    }
    
    func setCurrentAuthStatus(status: CLAuthorizationStatus) {
        //status를 확인해서 허용이면 accept하고 유저디폴트도 allowed로
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            UserDefaultsManager.shared.setValue(value: LocationAuthStatus.allowed.rawValue, type: .locationAuth)
        default:
            UserDefaultsManager.shared.setValue(value: LocationAuthStatus.restriced.rawValue, type: .locationAuth)
        }
        currentAuthStatus.accept(status)
    }

    func checkAuthorizationStatus() -> Bool {
        return UserDefaultsManager.shared.checkLocationAuth()
    }
    
    func setUserDefaultsAuth(type: LocationAuthStatus) {
        switch type {
        case .restriced:
            print("res")
            UserDefaultsManager.shared.setValue(value: LocationAuthStatus.restriced.rawValue, type: .locationAuth)
        case .allowed:
            print("allow")
            UserDefaultsManager.shared.setValue(value: LocationAuthStatus.allowed.rawValue, type: .locationAuth)
        }
    }
    
    func fetchUserData() {
        let api = SeSacAPI.signIn
        APIService.shared.request(type: SignIn.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { data, statusCode in
            guard let status = LoginError(rawValue: statusCode) else { return }
            guard let data = data else { return }
            print("인포쪽 \(statusCode) \(data)")
            switch status {
            case .signUpSuccess:
                print("성공적이죠?")
                UserDefaultsManager.shared.setValue(value: data, type: .userInfo)
            default:
                print("실패6548948")
            }
        }
    }
    
    func addAnnotation(map: MKMapView, data: AroundSesacSearch) {
        data.fromQueueDB.forEach {
            let coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
            guard let image = Annotation(rawValue: $0.sesac) else { return }
            let annotation = CustomAnnotation(coordinate: coordinate, imageNumber: image)
            annotation.coordinate = coordinate
            map.addAnnotation(annotation)
        }
        data.fromQueueDBRequested.forEach {
            let coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
            guard let image = Annotation(rawValue: $0.sesac) else { return }
            let annotation = CustomAnnotation(coordinate: coordinate, imageNumber: image)
            annotation.coordinate = coordinate
            map.addAnnotation(annotation)
        }
    }
    
    func sendCurrentLocation(location: BehaviorRelay<CLLocationCoordinate2D>) {
        location.accept(currentLocation.value)
    }
}
