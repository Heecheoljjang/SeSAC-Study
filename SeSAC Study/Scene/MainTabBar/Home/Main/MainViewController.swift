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

/*
 
위치 변수를 하나만 두기때문에 맵을 이동시킬때마다 setRegion을 해준다면 불편할것임.
 -> locationManager가 이용되었을때 selectedLocation값 변경과 함께 사용해보는걸로.
 
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
        viewModel.fetchUserData() //유저디폴트에 데이터세팅 => 가져온 뒤에 myqueuestate를 하게 해야함
    }
    
    override func configure() {
        super.configure()
        mainView.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
        
        viewModel.fetchQueueState() //버튼 세팅
        viewModel.setMapViewLocation(mapView: mainView.mapView)
        locationManager.requestWhenInUseAuthorization()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.tabBar.isHidden = true
    }

    func bind() {
        viewModel.searchList
            .asDriver(onErrorJustReturn: AroundSesacSearch(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: []))
            .drive(onNext: { [unowned self] value in
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
                //누르기 전에 현재 선택된 위치 유저디폴트에 저장
//                self?.viewModel.setLocationUserDefaults()
                self?.transitionViewController()
            })
            .disposed(by: disposeBag)

        viewModel.selectedLocation
            .asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: SeSacLocation.lat.value, longitude: SeSacLocation.lon.value))
            .drive(onNext: { [weak self] value in
                //위치로 서버통신해서 맵뷰에 표시 -> 데이터에 값이 들어왔을때 업데이트 해주는 형식으로 하면될듯
                print("서치 진행 \(value)")
                self?.viewModel.setLocationUserDefaults()
                self?.viewModel.startSeSacSearch(location: value)
            })
            .disposed(by: disposeBag)

        //gps버튼을 누를때, 위치권한이 허용으로 바뀌었을 경우에만 실행
        locationManager.rx.didUpdateLocations
            .subscribe(onNext: { [weak self] value in
                if let coordinate  = value.locations.last?.coordinate {
                    print("현재 사용자 위치: \(coordinate)")
                    self?.setRegion(center: coordinate)
                }
                self?.locationManager.stopUpdatingLocation()
            })
            .disposed(by: disposeBag)
        
        locationManager.rx.didChangeAuthorization
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                print("권한바뀜")
                vc.viewModel.setMapView(locationManager: vc.locationManager, mapView: vc.mainView.mapView)
            })
            .disposed(by: disposeBag)

        locationManager.rx.didError
            .bind(onNext: { [weak self] _ in
                self?.handlerAlert(title: AlertText.locationAuth.title, message: AlertText.locationAuth.message) { _ in
                    //MARK: - 아이폰 설정으로 이동시키기
                    print("아이폰 설정으로 이동")
                }
            })
            .disposed(by: disposeBag)

        //gps 버튼
        mainView.myLocationButton.rx.tap
            .bind(onNext: { [weak self] _ in
                //MARK: 위치 못불러오면 알아서 didError로 가기때문에 얼럿띄워짐
                self?.locationManager.startUpdatingLocation()
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController {
    private func transitionViewController() {
        let authStatus = viewModel.checkLocationAuth(locationManager: locationManager)
        print("현재 권한은 \(authStatus)")
        switch viewModel.fetchMatchingStatus() {
        case .normal:
            switch authStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                let vc = HobbyViewController()
//                viewModel.sendCurrentLocation(location: vc.viewModel.currentLocation)
                viewModel.setLocationUserDefaults()
                transition(vc, transitionStyle: .push)
            default:
                handlerAlert(title: AlertText.locationAuth.title, message: AlertText.locationAuth.message) { _ in
                    //MARK: - 아이폰 설정으로 이동시키기
                    print("아이폰 설정으로 이동")
                }
            }
        case .matching:
            //다시 돌아올 수도 있으므로
            let firstVC = HobbyViewController()
            let secondVC = NearUserViewController()
            if var navstack = navigationController?.viewControllers{
                navstack.append(contentsOf: [firstVC, secondVC])
                navigationController?.setViewControllers(navstack, animated: true)
            }
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
        print("센터센터: \(center)")
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 800, longitudinalMeters: 800)
        mainView.mapView.setRegion(region, animated: true)
    }
}

//MARK: - RxMKMapView써볼수도
extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.isUserInteractionEnabled = false
        mapView.removeAnnotations(mapView.annotations)
        let center = mapView.centerCoordinate
        print("center: \(center)")
        viewModel.setSelectedLocation(location: center)
        
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
