
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

    let repository = RealmRepository()
    var tasks: Results<EggTime>!

    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        tasks = repository.fetch()
        setpin()

//        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 203/255, green: 214/255, blue: 220/255, alpha: 1.0)
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
    
    
    let clusterManager = ClusterManager()


    lazy var naverMapView = NMFNaverMapView(frame: view.frame) // UIView
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(tapsoakButton) )
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(xmarkClicked) ) //지워도됨
//        
        navigationController?.navigationBar.barTintColor = .clear
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()


        naverMapView.mapView.zoomLevel = 17
        naverMapView.mapView.positionMode = .direction

//        naverMapView.mapView.touchDelegate = self
        naverMapView.mapView.addCameraDelegate(delegate: self)
        naverMapView.mapView.addOptionDelegate(delegate: self)
        naverMapView.mapView.isIndoorMapEnabled = true //실내지도
        
        view.addSubview(naverMapView)
        view.addSubview(mapview.backGroundView2)
            mapview.backGroundView2.snp.remakeConstraints {
                $0.top.equalTo(0)
                $0.leading.trailing.equalTo(0)
                $0.height.equalTo(100)
        }

        naverMapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(0)
        }

    }
//    @objc func xmarkClicked() {
//        dismiss(animated: true)
//    }


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
    func setpin() {
        if !tasks.isEmpty {
            tasks.forEach { task in
                let marker = NMFMarker(position: NMGLatLng(lat: task.latitude!, lng: task.longitude!))
//                marker.isHideCollidedMarkers = true // 여러개 모여있으면 숨겨주는기능
//                marker.captionText = task.title
                marker.touchHandler = { (overlay) in
                    if let marker = overlay as? NMFMarker {
                        if marker.iconImage.reuseIdentifier == "\(self.sdkBundle.bundleIdentifier ?? "").mSNormal" {
//                             marker.iconImage = NMFOverlayImage(name: "mSNormalNight", in: Bundle.naverMapFramework())
                            [self.mapview.popup,self.mapview.centerView,self.mapview.title,self.mapview.detailButton,self.mapview.image,self.mapview.checkButton].forEach {
                                self.view.addSubview($0)
                            }
                            self.show()
                            self.mapview.title.text = task.title
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
        
        self.mapview.title.snp.remakeConstraints {
            $0.bottom.equalTo(self.mapview.centerView.snp.top)
            $0.height.equalTo(30)
            $0.width.equalTo(self.mapview.image.snp.width)
            $0.leading.equalTo(self.mapview.image.snp.leading)
        }
        
        self.mapview.centerView.snp.remakeConstraints {
            $0.width.height.equalTo(300)
            $0.center.equalTo(self.view)
        }
        
        self.mapview.popup.snp.remakeConstraints {
            $0.edges.equalTo(self.view)
        }
        self.mapview.image.snp.remakeConstraints {
            $0.center.equalTo(self.view)
            $0.height.width.equalTo(300)
        }
        self.mapview.checkButton.snp.remakeConstraints {
            $0.top.equalTo(self.mapview.image.snp.bottom).offset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(self.mapview.image.snp.width).multipliedBy(0.3)
            $0.leading.equalTo(self.mapview.image.snp.leading).offset(5)
        }
        self.mapview.detailButton.snp.remakeConstraints {
            $0.top.equalTo(self.mapview.image.snp.bottom).offset(20)
            $0.height.equalTo(30)
            $0.width.equalTo(self.mapview.image.snp.width).multipliedBy(0.5)
            $0.trailing.equalTo(self.mapview.image.snp.trailing).offset(-5)
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
    }

    @objc func detailButtonClicked() {
        let vc = ListViewController()
        transition(vc,transitionStyle: .presentFullNavigation)
    }
}
