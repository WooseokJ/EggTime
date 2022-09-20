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

class MapViewController: BaseViewController,NMFMapViewCameraDelegate, CLLocationManagerDelegate, NMFMapViewOptionDelegate {
    
    let mapview = MapView()
    
    override func loadView() {
        super.view = mapview
    }
    
    var locationManager = CLLocationManager()
    var latitude: Double?
    var longtitude: Double?
    
    let repository = RealmRepository()
    var tasks: Results<EggTime>!
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        tasks = repository.fetch()
        setpin()
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
    }
    
    var distanceArray: [CLLocationDistance] = []
    var markers = [NMFMarker]()
    let infoWindow = NMFInfoWindow()
    let dataSource = NMFInfoWindowDefaultTextSource.data()
    let sdkBundle = Bundle.naverMapFramework()


    lazy var naverMapView = NMFNaverMapView(frame: view.frame) // UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action:#selector(tapsoakButton) )
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        
        
//        naverMapView.showCompass = true
//        naverMapView.showZoomControls = true
//        naverMapView.showIndoorLevelPicker = true
//        naverMapView.mapView.isZoomGestureEnabled = true
        
        
        naverMapView.mapView.zoomLevel = 17
        naverMapView.mapView.positionMode = .direction
        
//        naverMapView.mapView.touchDelegate = self
        naverMapView.mapView.addCameraDelegate(delegate: self)
        naverMapView.mapView.addOptionDelegate(delegate: self)
        naverMapView.mapView.isIndoorMapEnabled = true //실내지도
        
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
        print(#function)
        if let location = locations.first {
            //현위치 좌표
            print("현재좌표:",location.coordinate.latitude)
            print("현재좌표:",location.coordinate.longitude)
            distanceArray.removeAll()
            
            naverMapView.showLocationButton = true
            naverMapView.mapView.positionMode = .direction
            
            tasks.forEach{
                //MARK: 거리 계산하는 매소드
                let containDistance = location.distance(from: CLLocation(latitude: CLLocationDegrees($0.latitude ?? 0), longitude: CLLocationDegrees($0.longitude ?? 0)))
                print("차이거리:", containDistance)
                if containDistance <= 100 {
                    distanceArray.append(containDistance)
                }
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
    
//    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        print(#function)
//        if !UserDefaults.standard.bool(forKey: "tapped") {
//
//            let markerHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
//                guard let self = self else { return false }
//                self.view.addSubview(self.mapview.popup)
//                return true
//            }
//
////            markers[0].touchHandler = markerHandler
////                    self?.dataSource.title = marker2.userInfo["tag"] as! String
////                    print(self?.dataSource.title)
////                        self?.infoWindow.dataSource = self!.dataSource
//////                    self?.infoWindow.position = NMGLatLng(lat: marker2.userInfo["lat"] as! Double , lng:   marker2.userInfo["lng"] as! Double)
////
////    //                    self?.infoWindow.open(with: self!.naverMapView.mapView)
////                        // 마커를 터치할 때 정보창을 엶
////                    self?.infoWindow.open(with: marker2)
////                }
//        } else {
//
//        }
//        let select = UserDefaults.standard.bool(forKey: "tapped") ? false : true
//        UserDefaults.standard.set(select, forKey: "tapped")
//
//
//
//    }
    func setpin() {
        if !tasks.isEmpty {
            tasks.forEach { task in
                let marker = NMFMarker(position: NMGLatLng(lat: task.latitude!, lng: task.longitude!))
                
                marker.captionText = task.title
                marker.touchHandler = { (overlay) in
                    if let marker = overlay as? NMFMarker {
                        if marker.iconImage.reuseIdentifier == "\(self.sdkBundle.bundleIdentifier ?? "").mSNormal" {
//                             marker.iconImage = NMFOverlayImage(name: "mSNormalNight", in: Bundle.naverMapFramework())
                            [self.mapview.popup,self.mapview.image,self.mapview.checkButton].forEach {
                                self.view.addSubview($0)
                            }
                            self.show()
                            
                            self.mapview.image.contentMode = .scaleToFill
                            
                            if task.imageList.count != 0 {
                                self.mapview.image.image = self.loadImageFromDocument(fileName: task.imageList[0])
                            } else {
                                self.mapview.image.image = UIImage(named: "NoImage")
                            }
                            

                            
                            
                           return true
                         } else {
                             self.hidden()
//                             marker.iconImage = NMFOverlayImage(name: "mSNormal", in: Bundle.naverMapFramework())
                         }
                    }
                    return true
                    
                }
            
                
                marker.mapView = naverMapView.mapView
                infoWindow.open(with: marker)
                
                
            }
        }
    }
    
    @objc func checkButtonClicked() {
        hidden()
    }
    func show() {
        
        self.mapview.popup.snp.remakeConstraints {
            $0.edges.equalTo(self.view)
        }
        self.mapview.image.snp.remakeConstraints {
            $0.center.equalTo(self.view)
            $0.height.width.equalTo(200)
        }
        self.mapview.checkButton.snp.remakeConstraints {
            $0.top.equalTo(self.mapview.image.snp.bottom).offset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(200)
            $0.leading.equalTo(self.mapview.image.snp.leading).offset(5)
        }
        self.mapview.checkButton.addTarget(self, action: #selector(self.checkButtonClicked), for: .touchUpInside)
    }

    
    func hidden() {
        self.mapview.popup.snp.remakeConstraints {
            $0.height.width.equalTo(0)
        }
        self.mapview.image.snp.remakeConstraints {
            $0.height.width.equalTo(0)
        }
        self.mapview.checkButton.snp.remakeConstraints {
            $0.height.width.equalTo(0)
        }
    }

}
//
//extension MapViewController: NMFMapViewTouchDelegate {
//    public func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//        let alertController = UIAlertController(title: "지도 클릭", message: "", preferredStyle: .alert)
//        present(alertController, animated: true) {
//            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 0.5), execute: {
//                alertController.dismiss(animated: true, completion: nil)
//            })
//        }
//    }
//}
