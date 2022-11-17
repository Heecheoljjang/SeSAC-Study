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

final class HomeViewModel {
    
    //MARK: 서버통신 결과 받을 변수 만들어야함
    
    //나의 위치
    var currentLocation = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
    
    //위치를 잘 가져오면 accept로 위치 넣어서 서버통신. 잘 못가져오면 새싹 위치 accept
    var selectedLocation = PublishRelay<CLLocationCoordinate2D>()
    
    func removeUserDefatuls() {
        UserDefaultsManager.shared.removeSomeValue()
    }
    
    func setCurrentLocation(location: CLLocationCoordinate2D) {
        currentLocation.accept(location)
    }
    
    func fetchSeSac() {
        
    }
}
