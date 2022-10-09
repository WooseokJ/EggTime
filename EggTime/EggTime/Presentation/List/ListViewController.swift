

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
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

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
        if let location = locations.first {
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

        locationManager.stopUpdatingLocation() // stopUpdatingHeading 이랑 주의

    }

}
