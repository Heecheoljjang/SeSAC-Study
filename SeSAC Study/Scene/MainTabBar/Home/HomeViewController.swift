//
//  dfs.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import CoreLocation
import MapKit
import RxCocoa
import RxSwift

final class HomeViewController: ViewController {
    private var mainView = HomeView()
    private let viewModel = HomeViewModel()
    
    private let locationManager = CLLocationManager()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - 유저디폴트 지워주기
        viewModel.removeUserDefatuls()
        
        bind()
        
        //MARK: - 서버 통신해서 새싹 보여줘야함
        setRegion(center: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value)) //임시
        checkUserDeviceLocationServiceAuthorization()
    }
    
    override func configure() {
        super.configure()
        
        locationManager.delegate = self
        mainView.mapView.delegate = self
        
    }
    
    func bind() {

    }
}

extension HomeViewController {
    
    private func checkUserDeviceLocationServiceAuthorization() {
        print(#function)
        let authorizationStatus: CLAuthorizationStatus
        
        authorizationStatus = locationManager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            print("체크체크")
            checkUserCurrentLocationAuthorization(authorizationStatus)
        }
    }
    
    private func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        print(#function)
        
        switch status {
        case .notDetermined:
            //아직 앱이 위치서비스를 사용할지 선택하지않음
            print("notDetermined이니까 권한요청하기")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() //WhenInUse
        case .restricted, .denied:
            //권한 없음, 사용 거부
            print("권한없음. 지도의 중심 영등포로 하고 서버통신")
        
        case .authorizedAlways:
            //항상 허용, plist에서 추가안했음
            print("항상 허용했음")
        case .authorizedWhenInUse:
            //앱 사용시에만 허용
            print("사용시에만 허용했음")
            locationManager.startUpdatingLocation()
        case .authorized:
            //맥os에서 사용
            print("맥에서 씀")
        @unknown default:
            print("나중에 추가될수도있고 바뀔 수도 있는데 unknown default")
        }
    }
    
    //MARK: - Map
    private func setRegion(center: CLLocationCoordinate2D) {
        print("region설정")
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.setRegion(region, animated: true)

        //서버 통신 후 어노테이션 추가
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = center
//        annotation.title = "현재 위치"
//
//        mainView.mapView.addAnnotation(annotation)
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate  = locations.last?.coordinate {
            print("사용자 위치: \(coordinate)")
            setRegion(center: coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("사용자 위치 못가져옴")
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("위치 권한 바뀜;;;;;")
        checkUserDeviceLocationServiceAuthorization()
    }
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(#function)
        let center = mapView.centerCoordinate
        print("center: \(center)")
        //MARK: 서버통신해서 700미터 안의 새싹 위치에 어노테이션 추가 => accept해주면될듯
        setRegion(center: center)
    }
}
