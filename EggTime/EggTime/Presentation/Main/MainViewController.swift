

import UIKit
import NMapsMap
import SnapKit
import CoreLocation

class MainViewController: BaseViewController, CLLocationManagerDelegate {
    
    //MARK: 뷰 가져오기
    let mainview = MainView()
    
    override func loadView() {
        super.view = mainview
    }
    var locationManager: CLLocationManager! // location1
    let coord = NMGLatLng(lat: 37.4889112, lng:127.0657742)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "타임 캡슐 묻기"
        
        let naverMapView = NMFMapView(frame: view.frame)
        
        
        view.addSubview(naverMapView)
        
        naverMapView.snp.makeConstraints {
            $0.width.equalTo(400)
            $0.center.equalTo(view)
            $0.height.equalTo(340)
        }
        
        

        
        
        
//        naverMapView.showCompass = true // 나침반 모양
//        naverMapView.showZoomControls = true // +, - 버튼
//        naverMapView.showLocationButton = true //동그라미 버튼
        // NMFMapViewCameraDelegate Delegate 등록
//        naverMapView.mapView.addCameraDelegate(delegate: self)
  



        
        
        mainview.soakButton.addTarget(self, action: #selector(soakButtonClicked), for: .touchUpInside)
    }
    
    
    
    
    
}

//extension MainViewController: NMFMapViewCameraDelegate{
//
//    // 카메라 위치 변경시 좌표
//    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
//           print("카메라가 변경됨 : reason : \(reason)")
//           let cameraPosition = mapView.cameraPosition
//
//           print(cameraPosition.target.lat, cameraPosition.target.lng)
//
//    }
//
//}
