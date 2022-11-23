//
//  dfs.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/14.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift
import RxCoreLocation

/*
 처음
 - 현재 상태로 버튼 세팅
 - 현재 위치로 중심 세팅 => 위치권한 허용되면 내위치, 아니면 새싹
 - 설정된 위치를 가지고 search통신해서 지도에 이미지 보여주기
 */


final class MainViewController: ViewController {
    private var mainView = MainView()
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.fetchQueueState() //버튼 세팅
        viewModel.fetchUserData() //유저디폴트에 데이터세팅
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func configure() {
        super.configure()
            
        mainView.mapView.delegate = self
        navigationController?.navigationBar.isHidden = true
    }
    
    func bind() {
        
        viewModel.searchList
            .asDriver(onErrorJustReturn: AroundSesacSearch(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
            .drive(onNext: { [unowned self] value in
                print(value)
                self.viewModel.addAnnotation(map: self.mainView.mapView, data: value)
            })
            .disposed(by: disposeBag)
        
        //현재 상태에 따라 버튼 이미지 변경
        viewModel.currentStatus
            .asDriver(onErrorJustReturn: .normal)
            .drive(onNext: { [unowned self] value in
                self.mainView.findButton.configuration?.image = UIImage(named: value.imageName)
            })
            .disposed(by: disposeBag)
        
        mainView.findButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.transitionViewController()
            })
            .disposed(by: disposeBag)
        
        //gps버튼 누르면 didUpdateLocation실행되게해서 위치 받아오고 currentlocation에 넣어주면 요기서 setRegion해주기
        viewModel.currentLocation
            .asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
            .drive(onNext: { [weak self] value in
                print("현재위치 바뀌었음 \(value)")
                self?.setRegion(center: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedLocation
            .asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
            .drive(onNext: { [weak self] value in
                //위치로 서버통신해서 맵뷰에 표시 -> 데이터에 값이 들어왔을때 업데이트 해주는 형식으로 하면될듯
                print("서치 진행")
                self?.viewModel.fetchSeSacSearch(location: value)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentAuthStatus
            .asDriver(onErrorJustReturn: .notDetermined)
            .drive(onNext: { [weak self] value in
                switch value {
                case .notDetermined:
                    //아직 앱이 위치서비스를 사용할지 선택하지않음. 기본값을 여기서 설정해도될듯
                    print("notDetermined")
                    self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    self?.locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    print("권한없음. 지도의 중심 영등포로 하고 서버통신")
                    self?.viewModel.setCurrentLocation(location: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
                    //유저디폴트 바꿔야함
                    self?.viewModel.setUserDefaultsAuth(type: .restriced)
                case .authorizedWhenInUse, .authorizedAlways:
                    print("사용시에만 허용했음")
                    //유저디폴트
                    self?.viewModel.setUserDefaultsAuth(type: .allowed)
                    self?.locationManager.startUpdatingLocation()
                case .authorized:
                    print("맥에서 씀")
                @unknown default:
                    print("나중에 추가될수도있고 바뀔 수도 있는데 unknown default")
                }
            })
            .disposed(by: disposeBag)
        
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
                guard let coordinate = value?.coordinate else { return }
                print("내 위치 바뀜: \(coordinate)")
                self?.viewModel.setCurrentLocation(location: coordinate)
            })
            .disposed(by: disposeBag)
        
        //MARK: - 권한 바뀌면 실행 => 실행중에 나가서 권한 막을 수도 있음
        locationManager.rx.didChangeAuthorization
            .subscribe(onNext: { [weak self] _, status in
                print("권한바뀜")
                self?.viewModel.setCurrentAuthStatus(status: status)
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
                self?.locationManager.startUpdatingLocation()
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController {
    private func transitionViewController() {
        let authStatus = viewModel.checkAuthorizationStatus() //유저디폴트에 저장된거 가져오기
        print("현재 권한은 \(authStatus)")
        switch viewModel.fetchMatchingStatus() {
        case .normal:
            if authStatus {
                print("허용됨")
                let vc = HobbyViewController()
                viewModel.sendCurrentLocation(location: vc.viewModel.currentLocation)
                transition(vc, transitionStyle: .push)
            } else {
                print("권한이 막힘")
                //MARK: alert
            }
        case .matching:
            let vc = NearUserViewController()
            transition(vc, transitionStyle: .push)
        case .matched:
            let vc = ChattingViewController()
            transition(vc, transitionStyle: .push)
        }
    }
}

//MARK: - Map
extension MainViewController {
    private func setRegion(center: CLLocationCoordinate2D) {
        print("region설정")
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 800, longitudinalMeters: 800)
        mainView.mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
}

//MARK: - RxMKMapView써볼수도
extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.isUserInteractionEnabled = false
        mapView.removeAnnotations(mapView.annotations)
        let center = mapView.centerCoordinate
        print("center: \(center)")
        viewModel.selectedLocation.accept(center)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            mapView.isUserInteractionEnabled = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        
        var annotationView = mainView.mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else {
            annotationView?.annotation = annotation
        }
        
        switch annotation.imageNumber {
        case .basic:
            annotationView?.image = UIImage(named: Annotation.basic.image)
        case .strong:
            annotationView?.image = UIImage(named: Annotation.strong.image)
        case .mint:
            annotationView?.image = UIImage(named: Annotation.mint.image)
        case .purple:
            annotationView?.image = UIImage(named: Annotation.purple.image)
        case .gold:
            annotationView?.image = UIImage(named: Annotation.gold.image)
        }
        
        return annotationView
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
