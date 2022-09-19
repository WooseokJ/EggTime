//
//  MapViewController.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import UIKit
import NMapsMap
import CoreLocation
import SnapKit
import RealmSwift

class MapViewController: BaseViewController,NMFMapViewCameraDelegate,NMFMapViewTouchDelegate,CLLocationManagerDelegate, NMFMapViewOptionDelegate {
    
    var locationManager = CLLocationManager()
    var latitude: Double?
    var longtitude: Double?
    
    let repository = RealmRepository()
    var tasks: Results<EggTime>!
    
    override func viewWillAppear(_ animated: Bool) {
        tasks = repository.fetch()

        marker.tag = 0

        setpin()
       
    }

    var distanceArray: [CLLocationDistance] = []
    let marker = NMFMarker()
    let infoWindow = NMFInfoWindow()
    let dataSource = NMFInfoWindowDefaultTextSource.data()
    
    lazy var naverMapView = NMFNaverMapView(frame: view.frame) // UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action:#selector(tapsoakButton) )
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        naverMapView.showLocationButton = true
        naverMapView.mapView.zoomLevel = 17
        naverMapView.mapView.positionMode = .direction
        
        naverMapView.mapView.touchDelegate = self
        naverMapView.mapView.addCameraDelegate(delegate: self)
        naverMapView.mapView.addOptionDelegate(delegate: self)
        
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            
            //기본위치
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.553409 , lng: 126.969734 )) // 서울역위치
            cameraUpdate.animation = .easeIn
            naverMapView.mapView.moveCamera(cameraUpdate)
            
        } else {
            print("위치 서비스 Off 상태")
        }
        
        view.addSubview(naverMapView)
        
        naverMapView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension MapViewController {
    
    @objc func tapsoakButton(){
        let vc = WriteViewController()
        transition(vc,transitionStyle: .push)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //현위치 좌표
            print("현재좌표:",location.coordinate.latitude)
            print("현재좌표:",location.coordinate.longitude)
            
            tasks.forEach{
                //MARK: 거리 계산하는 매소드
                
                let contatinDistance = location.distance(from: CLLocation(latitude: CLLocationDegrees($0.latitude ?? 0), longitude: CLLocationDegrees($0.longitude ?? 0)))
                print("차이거리:",contatinDistance)
            }
            
            //현 위치로 카메라 이동
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude , lng: location.coordinate.longitude )) // 서울역위치
            cameraUpdate.animation = .easeIn
            naverMapView.mapView.moveCamera(cameraUpdate)
            
            print(distanceArray) // 거리의 모음
            
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "lat")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "lng")
        }
        
        // 위치 업데이트 멈춰 (실시간성이 중요한거는 매번쓰고, 중요하지않은건 원하는 시점에 써라)
        locationManager.stopUpdatingLocation() // stopUpdatingHeading 이랑 주의
        
    }
    
    // 탭할떄
  
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print(3)
        if UserDefaults.standard.bool(forKey: "tapped") {
            dataSource.title = tasks[0].title
            infoWindow.dataSource = dataSource
            infoWindow.position = NMGLatLng(lat: tasks[0].latitude! , lng:  tasks[0].longitude!)
            infoWindow.open(with: naverMapView.mapView)
            
        } else {
            infoWindow.close()
            
        }
        let select = UserDefaults.standard.bool(forKey: "tapped") ? false : true
        UserDefaults.standard.set(select, forKey: "tapped")
        

        
    }
    func setpin() {
        if !tasks.isEmpty {
            tasks.forEach {
               let marker = NMFMarker()
                print($0.latitude!,$0.longitude!)
                marker.position = NMGLatLng(lat: $0.latitude! , lng:  $0.longitude!)
                marker.mapView = naverMapView.mapView
                infoWindow.open(with: marker)
                
                let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
                    if let marker = overlay as? NMFMarker {
                        // 정보 창이 열린 마커의 tag를 텍스트로 노출하도록 반환
                        self?.dataSource.title = marker.userInfo["tag"] as! String
                        // 마커를 터치할 때 정보창을 엶
                        self?.infoWindow.open(with: marker)
                    }
                    return true
                };
                marker.userInfo = ["tag": $0.title]
                marker.touchHandler = handler
                marker.tag += 1
                
            }
            
        }
    }
    

}
