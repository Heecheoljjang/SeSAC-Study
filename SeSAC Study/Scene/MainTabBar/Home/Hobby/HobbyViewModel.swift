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
    
    var searchList = PublishRelay<SesacSearch>()
    
    var recommendList = BehaviorRelay<[String]>(value: [])
    var sesacStudyList = BehaviorRelay<[String]>(value: [])
    var mystudyList = BehaviorRelay<[String]>(value: [])
    
    var currentLocation = BehaviorRelay<CLLocationCoordinate2D>(value: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
    
    func fetchSeSacSearch(location: CLLocationCoordinate2D) {
        //searchList에 데이터 넣기
    }
    
    func fetchRecommendListCount() -> Int {
        return recommendList.value.count
    }
    
    func fetchSesacStudyListCount() -> Int {
        return sesacStudyList.value.count
    }
    
    func fetchMyStudyListCount() -> Int {
        return mystudyList.value.count
    }
}
