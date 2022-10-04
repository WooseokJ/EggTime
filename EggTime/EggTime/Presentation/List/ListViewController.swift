

import UIKit
import RealmSwift
import CoreLocation
import SnapKit

class ListViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let listView = ListView()
    override func loadView() {
        super.view = listView
    }

    let locationManager = CLLocationManager()

    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()

        } else {
            print("위치 서비스 Off 상태")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tasks = repository.fetch()
        if tasks.count == 0 {
            listView.contentlabel.snp.remakeConstraints {
                $0.center.equalTo(view)
                $0.height.equalTo(50)
                $0.leading.trailing.equalTo(0)
            }
            listView.contentlabel.text = "현재 묻은 타임캡슐이 없습니다."
        }
    }
    
    
    var tasks: Results<EggTime>! {
        didSet {
            listView.collectionview.reloadData()
            print("collectionview Tasks Changed")
        }
    }
    
    var openAvailable: [ObjectId] = []

    var currentlat: Double?
    var currentlng: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        listView.collectionview.dataSource = self
        listView.collectionview.delegate = self
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정

        
        self.navigationItem.backBarButtonItem = backBarButtonItem
        navigationItem.title = "타임 캡슐 리스트"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name
        ]
        //2
        navigationController?.navigationBar.titleTextAttributes = attributes

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        let setting = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingClicked))
        let home = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(homeClicked))
        let mapping =  UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapShowButtonClicked))

        self.navigationItem.rightBarButtonItems = [setting,home]
        self.navigationItem.leftBarButtonItem = mapping
    }
    
    @objc func homeClicked() {
        let vc = MainViewController()
        transition(vc,transitionStyle: .presentFullNavigation)
    }
    @objc func settingClicked() {
        let vc = SettingViewController()
        transition(vc,transitionStyle: .presentFullNavigation)
    }
    // 지도보기 버튼
    @objc func mapShowButtonClicked() {
        let vc = MapViewController()
        transition(vc,transitionStyle: .push)
    }




}

extension ListViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let location = locations.first {
            //현위치 좌표
            print("현재좌표:",location.coordinate.latitude)
            print("현재좌표:",location.coordinate.longitude)

            currentlat = location.coordinate.latitude
            currentlng = location.coordinate.longitude
            
            tasks.forEach{
                //MARK: 거리 계산하는 매소드
                let containDistance = location.distance(from: CLLocation(latitude: CLLocationDegrees($0.latitude ?? 0), longitude: CLLocationDegrees($0.longitude ?? 0)))
                if containDistance < 100 {
                    openAvailable.append($0.objectId)
                }
            }
            

        }

        // 위치 업데이트 멈춰 (실시간성이 중요한거는 매번쓰고, 중요하지않은건 원하는 시점에 써라)
        locationManager.stopUpdatingLocation() // stopUpdatingHeading 이랑 주의

    }

}
