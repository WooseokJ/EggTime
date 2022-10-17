
import UIKit
import NMapsMap
import CoreLocation
import SnapKit
import RealmSwift

class MapViewController: BaseViewController,NMFMapViewCameraDelegate, NMFMapViewOptionDelegate {
    
    let mapview = MapView()
    
    override func loadView() {
        super.view = mapview
    }
    
    var locationManager = CLLocationManager() // 위치
    var tasks: Results<EggTime>! // realm 데이터
    let circle = NMFCircleOverlay() // 원
    var deleteObjectid: ObjectId? // 지울 object
    
    var timer: Timer? // 타이머
    var markers = [NMFMarker]() // 마커 모음.
    var selectTask: EggTime?
    
    override func viewWillAppear(_ animated: Bool) {
        tasks = repository.fetch()

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "타임 캡슐 묻은 장소"
        navigationItem.backButtonTitle = " "
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapview.naverMapView.mapView.addCameraDelegate(delegate: self)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // 거리 원
            circle.center = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            circle.radius = 100
            circle.mapView = mapview.naverMapView.mapView
            circle.outlineWidth = 1
            circle.outlineColor = UIColor.systemBlue
            circle.fillColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.1)
            // 카메라 이동
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude , lng: location.coordinate.longitude ))
            cameraUpdate.animation = .easeIn
            mapview.naverMapView.mapView.moveCamera(cameraUpdate)
        }
        // 위치 업데이트 멈춰 (실시간성이 중요한거는 매번쓰고, 중요하지않은건 원하는 시점에 써라)
        locationManager.stopUpdatingLocation() // stopUpdatingHeading 이랑 주의
    }
    
    // 탭할떄
    func setpin() {
        if !tasks.isEmpty {
            tasks.enumerated().forEach { [self] index,task in
                let marker = NMFMarker(position: NMGLatLng(lat: task.latitude!, lng: task.longitude!))
                markers.append(marker)
                markers[index].mapView = mapview.naverMapView.mapView
                if markers[index].infoWindow == nil {
                    // 현재 마커에 정보 창이 열려있지 않을 경우 엶
                    markers[index].infoWindow?.open(with: markers[index])
                } else {
                    // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                    markers[index].infoWindow?.close()
                }
                
                selectTask = task
                
                markers[index].touchHandler = { [self] (overlay) in
                    if let marker = overlay as? NMFMarker {
                        [mapview.popup,mapview.centerView,mapview.title,mapview.detailButton,mapview.image,mapview.checkButton,mapview.lineView,mapview.leaveTimeLabel,mapview.leaveDayLabel,mapview.leaveTitle].forEach {
                            view.addSubview($0)
                        }
                        mapview.title.text = "\(task.title)님이 묻은 타임캡슐"
                        self.mapview.image.contentMode = .scaleToFill
                        let date = Date()
                        var minDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: task.openDate)
                        leaveTimeFunc()
                        self.mapview.leaveTitle.text = "오픈까지 남은기간"

                        let time = String(format: "%02d:", minDate.hour!)+String(format: "%02d:", minDate.minute!)+String(format: "%02d", minDate.second!)
                     
                        if minDate.month! != 0 { // 7개월 3일 12:03:02
                            mapview.leaveDayLabel.text = "\(minDate.month!)개월 \(minDate.day!)일 "
                            mapview.leaveTimeLabel.text  = time
                        }
                        else if minDate.day! != 0 {
                            mapview.leaveDayLabel.text = "\(minDate.day!)일"
                            mapview.leaveTimeLabel.text  = time
                        }
                        else if minDate.hour! != -1 {
                            mapview.leaveDayLabel.text = "내일 오픈 가능"
                            mapview.leaveTimeLabel.text = time
                        }

                        if date >= task.openDate{
                            hidden()
                            if task.imageList.count != 0 {
                                mapview.image.image = loadImageFromDocument(fileName: task.imageList[0])
                            } else {
                                
                                mapview.image.image = UIImage(named: "NoImage")
                            }
                        }
                        // 오픈일 지낫는데 거리가 멀어
                        else if date >= task.openDate {
                            mapview.leaveTitle.text = ""
                            mapview.leaveDayLabel.text = "해당 거리에서는 "
                            mapview.leaveTimeLabel.text = "열수 없습니다."
                            mapview.image.contentMode = .scaleAspectFit
                            mapview.image.image = UIImage(named: "EggImage")
                            
                        }
                        else {
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
                                let time = String(format: "%02d:", minDate.hour!)+String(format: "%02d:", minDate.minute!)+String(format: "%02d", minDate.second!)
                                
                                
                                if minDate.month! > 0 { // 7개월 3일 12:03:02
                                    mapview.leaveDayLabel.text = "\(minDate.month!)개월 \(minDate.day!)일 "
                                    mapview.leaveTimeLabel.text  = time
                                }
                                else if minDate.day! > 0 {
                                    mapview.leaveDayLabel.text = "\(minDate.day!)일"
                                    mapview.leaveTimeLabel.text  = time
                                }
                                else if minDate.hour! > 0 {
                                    mapview.leaveDayLabel.text = "내일 오픈 가능"
                                    mapview.leaveTimeLabel.text = time
                                }
                            }
                            mapview.image.contentMode = .scaleAspectFit
                            mapview.image.image = UIImage(named: "EggImage")
                        }
                        show()
                        return true
                    } else {
                        hidden()
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
        
        mapview.checkButton.addTarget(self, action: #selector(checkButtonClicked), for: .touchUpInside)
        mapview.detailButton.addTarget(self, action: #selector(detailButtonClicked), for: .touchUpInside)
        
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
        self.mapview.leaveTitle.snp.remakeConstraints {
            $0.width.height.equalTo(0)
        }
        self.mapview.leaveTimeLabel.snp.remakeConstraints {
            $0.width.height.equalTo(0)
        }
        self.mapview.leaveDayLabel.snp.remakeConstraints {
            $0.width.height.equalTo(0)
        }
    }
    
    @objc func detailButtonClicked() {
        
        
        guard selectTask!.openDate < Date()  else {
            showAlertMessage(title: "아직 오픈가능한 시간이아닙니다.", button: "확인")
            return
        }
        let vc = DetailViewController()
        transition(vc,transitionStyle: .push)
        vc.navigationItem.backBarButtonItem?.tintColor = AllColor.textColor.color
        vc.navigationItem.title = "자세히 보기"
        vc.objectid = selectTask!.objectId
    }
    
    func leaveTimeFunc() {
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
    }
}
