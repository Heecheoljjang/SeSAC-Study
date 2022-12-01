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

    var currentStatus = BehaviorRelay<MatchingStatus>(value: .normal)
    
    var selectedLocation = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))

    func setSelectedLocation(location: CLLocationCoordinate2D) {
        selectedLocation.accept(location)
    }
    
    func startSeSacSearch(location: CLLocationCoordinate2D) {
        let api = SeSacAPI.queueSearch(lat: location.latitude, lon: location.longitude)

        APIService.shared.request(type: AroundSesacSearch.self, method: .post, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in
            print(statusCode)
            guard let error = SesacSearchError(rawValue: statusCode) else {
                print("실패했음 도대체 왜")
                return }
            switch error {
            case .searchSuccess:
                guard let data = data else { return }
                print("새싹친구 통신성공: \(data)")
                self?.searchList.accept(data)
            case .tokenError:
                //MARK: - 토큰 재발급 후 다시 시도
                FirebaseManager.shared.fetchIdToken { result in
                    switch result {
                    case .success(let token):
                        UserDefaultsManager.shared.setValue(value: token, type: .idToken)
                        self?.startSeSacSearch(location: location)
                    case .failure(let error):
                        print("아이디토큰 못받아옴 \(error)")
                        return
                    }
                }
            default:
                print("새싹 친구 검색에러: \(error)")
            }
        }
    }
    
    func fetchQueueState() {
        print("queuestate 실행됨")
        let api = SeSacAPI.myQueueState

        APIService.shared.request(type: MyQueueState.self, method: .get, url: api.url, parameters: api.parameters, headers: api.headers) { [weak self] (data, statusCode) in
            print("queueState 상태코드 \(statusCode), data: \(data)")
            guard let error = QueueStateError(rawValue: statusCode) else {
                print("에러떠서 queuestate못가져옴")
                return }
            switch error {
            case .checkSuccess:
                guard let data = data else {
                    print("Queuestate통신 데이터 못가져옴")
                    return }
            
                UserDefaultsManager.shared.setValue(value: data.matchedUid ?? "", type: .otherUid)
                print("유아이디 저장완료 \(UserDefaultsManager.shared.fetchValue(type: .otherUid) as! String)")
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
    
//    func sendCurrentLocation(location: BehaviorRelay<CLLocationCoordinate2D>) {
//        location.accept(selectedLocation.value)
//    }
    func setLocationUserDefaults() {
        let location = selectedLocation.value
        let lat = location.latitude
        let long = location.longitude
        print("로케이션 저장 \(lat) \(long)")
        UserDefaultsManager.shared.setValue(value: lat, type: .lat)
        UserDefaultsManager.shared.setValue(value: long, type: .long)
        print("로케이션 저장된 값 \(UserDefaultsManager.shared.fetchValue(type: .lat) as? Double)")
    }
    
    func checkLocationAuth(locationManager: CLLocationManager) -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    func setMapView(locationManager: CLLocationManager, mapView: MKMapView) {
        /*
         - 권한 확인 후 notDet~인 경우엔 권한요청
         - 허용되어있는 경우엔 내 위치로
         - 허용되어있지 않다면 새싹위치로
         */
        let auth = checkLocationAuth(locationManager: locationManager)
        switch auth {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            let baseLocation = CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value)
            selectedLocation.accept(baseLocation)
            let region = MKCoordinateRegion(center: baseLocation, latitudinalMeters: 800, longitudinalMeters: 800)
            mapView.setRegion(region, animated: true)
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("나머지")
        }
    }
    
    func setMapViewLocation(mapView: MKMapView) {
        guard let lat = UserDefaultsManager.shared.fetchValue(type: .lat) as? Double,
        let long = UserDefaultsManager.shared.fetchValue(type: .long) as? Double else { return }
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(region, animated: true)
    }
}

