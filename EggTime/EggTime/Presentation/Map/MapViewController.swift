
import UIKit
import NMapsMap
import CoreLocation
import SnapKit
import RealmSwift
import Cluster

class MapViewController: BaseViewController,NMFMapViewCameraDelegate, CLLocationManagerDelegate, NMFMapViewOptionDelegate {
    
    let mapview = MapView()
    
    override func loadView() {
        super.view = mapview
    }
    
    var locationManager = CLLocationManager()
    var latitude: Double?
    var longtitude: Double?
    var tasks: Results<EggTime>!
    
    let circle = NMFCircleOverlay()
    
    var deleteObjectid: ObjectId?
    
    override func viewWillAppear(_ animated: Bool) {
        
        markers.forEach {
            $0.mapView = nil
        }
    
        markers.removeAll()
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            
            locationManager.startUpdatingLocation()
            
            
            
        } else {
            print("위치 서비스 Off 상태")
        }
        
        setpin()
        hidden()
        
        navigationItem.title = "타임 캡슐 묻은 장소"
        navigationItem.backButtonTitle = " "
        
    }
    
    var timer: Timer?
    var detailTask: EggTime?
    
    var distanceArray: [CLLocationDistance] = []
    
    var markers = [NMFMarker]()
    let infoWindow = NMFInfoWindow()
    let dataSource = NMFInfoWindowDefaultTextSource.data()
    let sdkBundle = Bundle.naverMapFramework()
    let clusterManager = ClusterManager()
    
    lazy var naverMapView = NMFNaverMapView(frame: view.frame) // UIView
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
     
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        
        //현 위치로 카메라 이동
        
        naverMapView.showLocationButton = true
        naverMapView.showCompass = true
        naverMapView.showScaleBar = true
        naverMapView.showZoomControls = true
        naverMapView.showIndoorLevelPicker = true
        naverMapView.showsLargeContentViewer = true
        
        naverMapView.mapView.zoomLevel = 10
        naverMapView.mapView.positionMode = .direction
        
        naverMapView.mapView.addCameraDelegate(delegate: self)
        naverMapView.mapView.addOptionDelegate(delegate: self)
        naverMapView.mapView.isIndoorMapEnabled = true //실내지도
        
        view.addSubview(naverMapView)
        
        naverMapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(0)
        }
        
    }
}

extension MapViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longtitude = location.coordinate.longitude
            
            
            distanceArray.removeAll()
            
            
            tasks.forEach{
                //MARK: 거리 계산하는 매소드
                let containDistance = location.distance(from: CLLocation(latitude: CLLocationDegrees($0.latitude ?? 0), longitude: CLLocationDegrees($0.longitude ?? 0)))
                //                print("차이거리:", containDistance)
                if containDistance <= 100 {
                    distanceArray.append(containDistance)
                }
            }
            circle.center = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            circle.radius = 100
            circle.mapView = naverMapView.mapView
            circle.outlineWidth = 1
            circle.outlineColor = UIColor.systemBlue
            circle.fillColor = .clear
            
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude , lng: location.coordinate.longitude ))
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
    func setpin() {
        
        tasks = repository.fetch()
 
        locationManager.startUpdatingLocation()

        
        if !tasks.isEmpty {
            tasks.enumerated().forEach { [self] index,task in
                let marker = NMFMarker(position: NMGLatLng(lat: task.latitude!, lng: task.longitude!))
                markers.append(marker)
                
                markers[index].mapView = naverMapView.mapView
                if markers[index].infoWindow == nil {
                    
                    // 현재 마커에 정보 창이 열려있지 않을 경우 엶
                    markers[index].infoWindow?.open(with: markers[index])
                } else {
                    // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                    markers[index].infoWindow?.close()
                }
               
//                markers[index].isHideCollidedMarkers = true // 여러개 모여있으면 숨겨주는기능
                
                //                marker.captionText = task.title
                markers[index].touchHandler = { [self] (overlay) in
                    
                    if let marker = overlay as? NMFMarker {
                        detailTask = task
                        
                        [mapview.popup,mapview.centerView,mapview.title,mapview.detailButton,mapview.image,mapview.checkButton,mapview.lineView,mapview.leaveTimeLabel,mapview.leaveDayLabel,mapview.leaveTitle].forEach {
                            view.addSubview($0)
                        }
                        mapview.title.text = task.title
                        self.mapview.image.contentMode = .scaleToFill
                        let date = Date()
                        var minDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: task.openDate)
                        
                        
                        self.mapview.leaveTimeLabel.snp.remakeConstraints {
                            $0.centerY.equalTo(self.view).offset(30)
                            $0.centerX.equalTo(self.view)
                            $0.height.equalTo(50)
                            $0.leading.equalTo(self.mapview.centerView.snp.leading)
                            $0.trailing.equalTo(self.mapview.centerView.snp.trailing)
                        }
                        
                        self.mapview.leaveDayLabel.snp.remakeConstraints {
                            $0.height.equalTo(30)
                            $0.leading.equalTo(self.mapview.centerView.snp.leading)
                            $0.trailing.equalTo(self.mapview.centerView.snp.trailing)
                            $0.bottom.equalTo(self.mapview.leaveTimeLabel.snp.top).offset(-5)
                        }
                        
                        
                        self.mapview.leaveTitle.snp.remakeConstraints {
                            $0.bottom.equalTo(self.mapview.leaveTimeLabel.snp.top).offset(-30)
                            $0.height.equalTo(50)
                            $0.leading.equalTo(self.mapview.centerView.snp.leading)
                            $0.trailing.equalTo(self.mapview.centerView.snp.trailing)
                        }
                        
                        let time = String(format: "%02d:", minDate.hour!)+String(format: "%02d:", minDate.minute!)+String(format: "%02d", minDate.second!)
                        
                        
                        self.mapview.leaveTitle.text = "오픈까지 남은기간"
                        
                        if minDate.month! != 0 { // 7개월 3일 12:03:02
                            self.mapview.leaveDayLabel.text = "\(minDate.month!)개월 \(minDate.day!)일 "
                            self.mapview.leaveTimeLabel.text  = time
                        }
                        else if minDate.day! != 0 {
                            self.mapview.leaveDayLabel.text = "\(minDate.day!)일"
                            self.mapview.leaveTimeLabel.text  = time
                        }
                        else if minDate.hour! != -1 {
                            self.mapview.leaveDayLabel.text = "내일 오픈 가능"
                            self.mapview.leaveTimeLabel.text = time
                        }
                        
                        
                        if date >= task.openDate && !self.distanceArray.isEmpty{
                            self.mapview.leaveTitle.snp.remakeConstraints {
                                $0.width.height.equalTo(0)
                            }
                            self.mapview.leaveTimeLabel.snp.remakeConstraints {
                                $0.width.height.equalTo(0)
                            }
                            self.mapview.leaveDayLabel.snp.remakeConstraints {
                                $0.width.height.equalTo(0)
                            }
                            if task.imageList.count != 0 {
                                self.mapview.image.image = self.loadImageFromDocument(fileName: task.imageList[0])
                            } else {
                                
                                self.mapview.image.image = UIImage(named: "NoImage")
                            }
                        }
                        else {
                            
                            if self.timer != nil && self.timer!.isValid {
                                self.timer?.invalidate() //기존 타이머 시작하면 멈춤
                            }
                            
                            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
                                minDate.second! -= 1
                                
                                if minDate.second! == -1 {
                                    minDate.second! = 59
                                    minDate.minute! -= 1
                                }
                                if minDate.minute! == -1  {
                                    minDate.minute! = 59
                                    minDate.hour! -= 1
                                }
                                if minDate.hour! == -1 {
                                    timer.invalidate()
                                }
                                let time = String(format: "%02d:", minDate.hour!)+String(format: "%02d:", minDate.minute!)+String(format: "%02d", minDate.second!)
                                
                                
                                if minDate.month! != 0 { // 7개월 3일 12:03:02
                                    self.mapview.leaveDayLabel.text = "\(minDate.month!)개월 \(minDate.day!)일 "
                                    self.mapview.leaveTimeLabel.text  = time
                                }
                                else if minDate.day! != 0 {
                                    self.mapview.leaveDayLabel.text = "\(minDate.day!)일"
                                    self.mapview.leaveTimeLabel.text  = time
                                }
                                else if minDate.hour! != -1 {
                                    self.mapview.leaveDayLabel.text = "내일 오픈 가능"
                                    self.mapview.leaveTimeLabel.text = time
                                }
                            }
                            self.mapview.image.image = UIImage(named: "Egg2")
                        }
                        self.show()
                        
                        return true
                    } else {
                        self.hidden()
                    }
                    return true
                }
  
            } 
        }
    }
    
    @objc func checkButtonClicked() {
        hidden()
    }
    func show() {
        
        self.mapview.title.snp.remakeConstraints {
            $0.centerX.equalTo(mapview.centerView)
            $0.top.equalTo(mapview.centerView.snp.top)
            $0.width.equalTo(self.mapview.image.snp.width)
            $0.height.equalTo(self.mapview.centerView.snp.height).multipliedBy(0.08)
        }
        
        self.mapview.centerView.snp.remakeConstraints {
            $0.width.equalTo(300)
            $0.height.equalTo(500)
            $0.center.equalTo(self.view)
        }
        
        self.mapview.popup.snp.remakeConstraints {
            $0.edges.equalTo(self.view)
        }
        self.mapview.image.snp.remakeConstraints {
            $0.centerX.equalTo(mapview.centerView)
            $0.top.equalTo(mapview.title.snp.bottom)
            $0.leading.equalTo(mapview.centerView.snp.leading)
            $0.trailing.equalTo(mapview.centerView.snp.trailing)
            $0.bottom.equalTo(self.mapview.checkButton.snp.top)
        }
        self.mapview.checkButton.snp.remakeConstraints {
            $0.bottom.equalTo(self.mapview.centerView.snp.bottom)
            $0.height.equalTo(50)
            $0.width.equalTo(self.mapview.centerView.snp.width).multipliedBy(0.5)
            $0.leading.equalTo(self.mapview.centerView.snp.leading)
        }
        
        self.mapview.detailButton.snp.remakeConstraints {
            $0.height.equalTo(50)
            $0.width.equalTo(self.mapview.centerView.snp.width).multipliedBy(0.5)
            $0.trailing.equalTo(self.mapview.centerView.snp.trailing)
            $0.bottom.equalTo(self.mapview.centerView.snp.bottom)
        }
        self.mapview.lineView.snp.remakeConstraints {
            $0.height.equalTo(self.mapview.detailButton.snp.height)
            $0.width.equalTo(0.5)
            $0.centerX.equalTo(self.mapview.image)
            $0.top.equalTo(self.mapview.checkButton.snp.top)
            $0.bottom.equalTo(self.mapview.checkButton.snp.bottom)
        }
        
        self.mapview.checkButton.addTarget(self, action: #selector(self.checkButtonClicked), for: .touchUpInside)
        self.mapview.detailButton.addTarget(self, action: #selector(self.detailButtonClicked), for: .touchUpInside)
        
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
        self.mapview.detailButton.snp.remakeConstraints{
            $0.height.width.equalTo(0)
        }
        self.mapview.centerView.snp.remakeConstraints {
            $0.height.width.equalTo(0)
        }
        self.mapview.title.snp.remakeConstraints{
            $0.height.width.equalTo(0)
        }
        self.mapview.lineView.snp.remakeConstraints {
            $0.height.width.equalTo(0)
        }
    }
    
    @objc func detailButtonClicked() {
        
        guard detailTask!.openDate < Date() else {
            showAlertMessage(title: "아직 오픈가능한 시간이아닙니다.", button: "확인")
            return
        }
        
  
        let vc = DetailViewController()
        transition(vc,transitionStyle: .push)
        
        vc.navigationItem.backBarButtonItem?.tintColor = AllColor.textColor.color
        vc.navigationItem.title = "자세히 보기"
        vc.objectid = detailTask?.objectId


    }
}
