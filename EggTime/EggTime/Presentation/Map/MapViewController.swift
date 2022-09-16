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

class MapViewController: BaseViewController,NMFMapViewCameraDelegate,CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var latitude: Double?
    var longtitude: Double?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            print("위치 서비스 off")
        }
        
        
        let naverMapView = NMFNaverMapView(frame: view.frame)
        
        naverMapView.showLocationButton = true //현위치 버튼
        naverMapView.showCompass = true // 나침반 모양
        naverMapView.showIndoorLevelPicker = true
        naverMapView.showScaleBar = true
        naverMapView.showZoomControls = true
        
        view.addSubview(naverMapView)
        
        naverMapView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
       
        

        
      
    


        //        let marker = NMFMarker()
        //        marker.position = NMGLatLng(lat: cameraPosition.target.lat, lng: cameraPosition.target.lng)
        //        marker.iconImage = NMF_MARKER_IMAGE_BLUE
        //        marker.iconTintColor = UIColor.red
        //
        //        marker.width = 25
        //        marker.height = 25
        //        marker.mapView = naverMapView
        //
        //        let infoWindow = NMFInfoWindow()
        //        let dataSource = NMFInfoWindowDefaultTextSource.data()
        //        dataSource.title = "네이버회사"
        //        infoWindow.dataSource = dataSource
        //        infoWindow.open(with: marker)
        //
//
//        naverMapView.showZoomControls = true // +, - 버튼
//        naverMapView.showLocationButton = true //동그라미 버튼
//
//        naverMapView.mapView.addCameraDelegate(delegate: self)
//
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("좌표:",location.coordinate.latitude)
            let coord = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        }
    }


}
