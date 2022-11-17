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
import RxCoreLocation

final class HomeViewController: ViewController {
    private var mainView = HomeView()
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.removeUserDefatuls()
        
        bind()
        
        //MARK: - 서버 통신해서 새싹 보여줘야함
        setRegion(center: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value)) //임시
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func configure() {
        super.configure()
            
        mainView.mapView.delegate = self
    }
    
    func bind() {
        
        //gps버튼 누르면 didUpdateLocation실행되게해서 위치 받아오고 currentlocation에 넣어주면 요기서 setRegion해주기
        viewModel.currentLocation
            .asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
            .drive(onNext: { [weak self] value in
                print("얘가 실행되는건가 초기값이 있어서")
                self?.setRegion(center: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedLocation
            .asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
            .drive(onNext: { [weak self] value in
                //위치로 서버통신해서 맵뷰에 표시 -> 데이터에 값이 들어왔을때 업데이트 해주는 형식으로 하면될듯
                
            })
            .disposed(by: disposeBag)
        
        //gps버튼 -> startUpdating해서 메서드 실행
        locationManager.rx.didUpdateLocations
            .subscribe(onNext: { [weak self] value in
                if let coordinate  = value.locations.last?.coordinate {
                    print("현재 사용자 위치: \(coordinate)")
                    self?.viewModel.setCurrentLocation(location: coordinate)
                }
                self?.locationManager.stopUpdatingLocation()
            })
            .disposed(by: disposeBag)
            
        //MARK: 내 위치 바뀌면 실행 => 맵뷰 움직이면 startUpdatingLocation실행되는데 이것때문에 실행되는듯
        locationManager.rx.location
            .subscribe(onNext: { [weak self] value in
                print("위치바뀜")
                print(value?.coordinate)
            })
            .disposed(by: disposeBag)
        
        //MARK: - 권한 바뀌면 실행 => 실행중에 나가서 권한 막을 수도 있음
        locationManager.rx.didChangeAuthorization
            .subscribe(onNext: { [weak self] manager, status in
                switch status {
                case .notDetermined:
                    //아직 앱이 위치서비스를 사용할지 선택하지않음
                    print("notDetermined이니까 권한요청하기")
                    manager.desiredAccuracy = kCLLocationAccuracyBest
                    manager.requestWhenInUseAuthorization() //WhenInUse
                case .restricted, .denied:
                    //권한 없음, 사용 거부
                    print("권한없음. 지도의 중심 영등포로 하고 서버통신")
                    
                case .authorizedAlways:
                    //항상 허용, plist에서 추가안했음
                    print("항상 허용했음")
                case .authorizedWhenInUse:
                    //앱 사용시에만 허용
                    print("사용시에만 허용했음")
                    manager.startUpdatingLocation()
                case .authorized:
                    //맥os에서 사용
                    print("맥에서 씀")
                @unknown default:
                    print("나중에 추가될수도있고 바뀔 수도 있는데 unknown default")
                }
            })
            .disposed(by: disposeBag)
        
        locationManager.rx.didError
            .bind(onNext: { [weak self] _ in
                print("위치를 가져오지 못했습니다.")
                //alert같은거 띄우면 될 것 같음
            })
            .disposed(by: disposeBag)
            
        //gps 버튼
        mainView.myLocationButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //센터값 구해서 setRegion해야함
                
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    
    //MARK: - Map
    private func setRegion(center: CLLocationCoordinate2D) {
        print("region설정")
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 800, longitudinalMeters: 800)
        mainView.mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        //MARK: 서버 통신 후 어노테이션 추가
    }
}

//MARK: - RxMKMapView써볼수도
extension HomeViewController: MKMapViewDelegate {
    
    //MARK: 위치를 옮길때마다 서버통신해야하므로 여기서 메서드 실행하는게 맞을듯
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
        let center = mapView.centerCoordinate
        print("center: \(center)")
        //MARK: 서버통신해서 어노테이션 추가 => accept해주면될듯
        viewModel.selectedLocation.accept(center)
    }
}


/* 헷갈려서 적는 플로우. 아직 메서드 넣기  전
 실행되자마자 setRegion 실행(bind에 의해서 currentLocation이 behaviorRelay이므로 초기값으로 세팅)
 -> regionDidChangeAnimated 실행
 -> 내부의 startUpdatingLocation 실행 -> rx.location 실행(nil출력. 아직 권한 허용하기 전이기때문)
 -> 이제 viewDidLoad의 setregion메서드로 맵뷰에 로케이션 세팅 -> regionDidChange실행되어 startUpdating실행
 -> 아직 권한 설정 전이므로 didError실행
 -> 이제 권한 요청 허용 -> didChangeAuthorization에서 whenInUse 실행돼서 startUpdatingLocation실행
 -> 그로인해 didUpdateLocation 실행 -> viewModel의 currentLocation에 값 accept -> bind된 setRegion다시 실행돼서 가져온 위치로 맵뷰 세팅 -> 위치 가져오면서 위치가 바뀌었으므로 rx.location 다시 실행
 */
