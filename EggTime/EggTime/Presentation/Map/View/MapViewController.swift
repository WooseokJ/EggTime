
import UIKit
import NMapsMap
import CoreLocation
import SnapKit
import RealmSwift

final class MapViewController: BaseViewController,NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
    
    let mapview = MapView()
    
    override func loadView() {
        super.view = mapview
    }
    
    var locationManager = CLLocationManager()
    var tasks: Results<EggTime>!
    let circle = NMFCircleOverlay()
    
    var timer: Timer?
    var markers = [NMFMarker]()
    var selectTask: EggTime!
 
    var alldistanceArray: [CLLocationDistance] = []
    
    override func viewWillAppear(_ animated: Bool) {
        tasks = repository.fetch()
        markers.forEach {
            $0.mapView = nil
        }
        markers.removeAll()

        
        

        locationRequest()
        setpin()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "타임 캡슐 묻은 장소"
        navigationItem.backButtonTitle = " "
        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .plain, target: self, action: #selector(listClicked))
        mapview.naverMapView.mapView.addCameraDelegate(delegate: self)
        mapview.checkButton.addTarget(self, action: #selector(checkButtonClicked), for: .touchUpInside)
        mapview.detailButton.addTarget(self, action: #selector(detailButtonClicked), for: .touchUpInside)

    }
    
    @objc func checkButtonClicked() {
        mapview.popupHidden()
    }
    @objc func detailButtonClicked() {
        guard selectTask.openDate < Date()  else {
            showAlertMessage(title: "아직 오픈가능한 시간이아닙니다.", button: "확인")
            return
        }
        let vc = DetailViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        vc.navigationItem.title = "자세히 보기"
        vc.navigationItem.title = "\(selectTask.title)님의 타임 캡슐"
        vc.objectid = selectTask.objectId
    }
    
    @objc func listClicked() {
        let vc = ListViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    private func locationRequest() {
        locationManager.delegate = self
//        locationManager.desiredAccuracy = .
        
        locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                print("위치 서비스 On 상태")
                self.locationManager.startUpdatingLocation()
            } else {
                print("위치 서비스 Off 상태")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate.longitude, location.coordinate.latitude)
            UserDefaults.standard.set(location.coordinate.longitude + Double.random(in: 0.0002...0.0008) , forKey: "lng")
            UserDefaults.standard.set(location.coordinate.latitude + Double.random(in: 0.0002...0.0008), forKey: "lat")
            
            circle.center = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            circle.radius = 200
            circle.mapView = mapview.naverMapView.mapView
            circle.outlineWidth = 1
            circle.outlineColor = UIColor.systemBlue
            circle.fillColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.1)
            
            //MARK: 거리 계산하는 매소드
            alldistanceArray.removeAll()
            tasks.forEach {
                let containDistance = location.distance(from: CLLocation(latitude: CLLocationDegrees($0.latitude ?? 0), longitude: CLLocationDegrees($0.longitude ?? 0)))
                
                alldistanceArray.append(containDistance)
            }
            print(alldistanceArray)
  
            
            // 카메라 이동
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude , lng: location.coordinate.longitude))
            cameraUpdate.animation = .easeIn
            mapview.naverMapView.mapView.moveCamera(cameraUpdate)
        }
        // 위치 업데이트 멈춰 (실시간성이 중요한거는 매번쓰고, 중요하지않은건 원하는 시점에 써라)
        locationManager.stopUpdatingLocation() // stopUpdatingHeading 이랑 주의
    }

}


extension MapViewController {
    // 탭할떄
    func setpin() {
        guard !tasks.isEmpty else {return}
        
        
        tasks.enumerated().forEach { [self] index,task in
            guard let lat = task.latitude else {return}
            guard let lng = task.longitude else  {return}
            let marker = NMFMarker(position: NMGLatLng(lat: lat, lng: lng))
            marker.isHideCollidedMarkers = true // hiden 처리
            markers.append(marker)
            markers[index].mapView = mapview.naverMapView.mapView
            if markers[index].infoWindow == nil {
                // 현재 마커에 정보 창이 열려있지 않을 경우 엶
                markers[index].infoWindow?.open(with: markers[index])
            } else {
                // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                markers[index].infoWindow?.close()
            }
            
            
            markers[index].touchHandler = { [self] (overlay) in
                if overlay is NMFMarker {
                    mapview.title.text = "\(task.title)님이 묻은 타임캡슐"
                    let date = Date()
                    var minDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: task.openDate)
                    mapview.popupShow()
                    selectTask = task // 선택한것.
                    
                    mapview.image.contentMode = .scaleAspectFit
                    mapview.image.image = UIImage(named: "EggImage")
                    mapview.leaveTitle.isHidden = false
                    mapview.leaveDayLabel.isHidden = false
                    mapview.leaveTimeLabel.isHidden = false
                    
                    if minDate.month! > 0 { // 7개월 3일 12:03:02
                        mapview.leaveDayLabel.text = "\(minDate.month!)개월 \(minDate.day!)일 "
                    }
                    else if minDate.day! > 0 {
                        mapview.leaveDayLabel.text = "\(minDate.day!)일"
                    }
                    else if (minDate.hour! <= 0) && (minDate.minute! <= 0 ) && (minDate.second! <= 0 ) {
                        mapview.leaveTitle.isHidden = true
                        mapview.leaveDayLabel.isHidden = true
                        mapview.leaveTimeLabel.isHidden = true
                        
                        mapview.image.contentMode = .scaleToFill
                        switch task.imageList.isEmpty {
                        case true: mapview.image.image = UIImage(named: "NoImage")
                        default: mapview.image.image = loadImageFromDocument(fileName: task.imageList[0])
                        }
                        return true
                    }
                    else  {
                        mapview.leaveDayLabel.text = "오늘 자정 오픈"
                    }
                    
                    mapview.leaveTimeLabel.text  = String(format: "%02d:", minDate.hour! )+String(format: "%02d:", minDate.minute!)+String(format: "%02d", minDate.second!)

                    // 오픈일 지낫는데 거리가 멀어
                    
                    if timer != nil && timer!.isValid {
                        timer?.invalidate() //기존 타이머 시작하면 멈춤
                    }
                    

                    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
                        minDate.second! -= 1

                        if minDate.second! < 0 {
                            minDate.second! = 59
                            minDate.minute! -= 1
                        }
                        if minDate.minute! < 0  {
                            minDate.minute! = 59
                            minDate.hour! -= 1
                        }
                        if minDate.hour! < 0 {
                            timer.invalidate()
                        }

                        mapview.leaveTimeLabel.text  = String(format: "%02d:", minDate.hour!)+String(format: "%02d:", minDate.minute!)+String(format: "%02d", minDate.second!)
                    }
                    
                } else {
                    mapview.popupHidden()
                }
                return true
            }
        }
    }
}
