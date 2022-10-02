

import UIKit
import SnapKit
import RealmSwift
import UserNotifications
import CoreLocation

class MainViewController: BaseViewController {
    
    //MARK: 뷰 가져오기
    let mainview = MainView()
    override func loadView() {
        super.view = mainview
    }
    var timer: Timer?
    let date = Date()
    
    let locationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current() // 알람할떄 선행되야됨.

    var tasks: Results<EggTime>!

    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        tasks = repository.fetch()
        
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()

        } else {
            print("위치 서비스 Off 상태")
        }
        
        
        navigationItem.title = "홈"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]

        let date = Date()

        let min = repository.localRealm.objects(EggTime.self).filter("openDate >= %@",date).sorted(byKeyPath: "openDate", ascending: true)

        guard !min.isEmpty else {
            mainview.titleLabel.snp.remakeConstraints {
                $0.width.height.equalTo(0)
            }
            mainview.timelabel.snp.remakeConstraints {
                $0.width.height.equalTo(0)
            }
            mainview.dayLabel.snp.remakeConstraints {
                $0.width.height.equalTo(0)
            }
            mainview.tempLabel.snp.remakeConstraints {
                $0.height.equalTo(50)
                $0.center.equalTo(view)
                $0.leading.trailing.equalTo(0)
            }
            mainview.plusButton.snp.remakeConstraints {
                $0.bottom.equalTo(-55)
                $0.trailing.equalTo(-35)
                $0.height.width.equalTo(60)
            }
            
            
            mainview.tempLabel.text = "현재 열수있는 캡슐이 없습니다."
            

            return
        }
        mainview.titleLabel.snp.remakeConstraints {
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.view).offset(-100)
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(0)
        }
        

        mainview.dayLabel.snp.remakeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(mainview.titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(0)
        }
        
        mainview.timelabel.snp.remakeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(mainview.dayLabel.snp.bottom).offset(10)
            $0.height.equalTo(100)
            $0.leading.trailing.equalTo(0)
        }
        mainview.tempLabel.snp.remakeConstraints {
            $0.centerX.equalTo(view)
            $0.bottom.equalTo(mainview.titleLabel.snp.top).offset(-10)
            $0.height.equalTo(mainview.titleLabel.snp.height)
            $0.leading.trailing.equalTo(0)
            
        }
        
        mainview.titleLabel.text = "캡슐이름: "+min[0].title
        
        
        mainview.tempLabel.text = "가장 빨리 열수있는 캡슐까지 남은기간"

        var minDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: min[0].openDate)
        
        print(minDate)
        
   
        
        
        if timer != nil && timer!.isValid {
            timer?.invalidate() //기존 타이머 시작하면 멈춤
        }
        let time = String(format: "%02d:", minDate.hour!)+String(format: "%02d:", minDate.minute!)+String(format: "%02d", minDate.second!)

        if minDate.month != 0 { // 7개월 3일 12:03:02
            mainview.dayLabel.text = "\(minDate.month!)개월 \(minDate.day!)일 "
            mainview.timelabel.text = time
        }
        else if minDate.day != 0 {
            mainview.dayLabel.text = "\(minDate.day!)일"
            mainview.timelabel.text = time
        }
        else if minDate.hour != -1 {
            mainview.dayLabel.text = "내일 오픈 가능"
            mainview.timelabel.text = time
        }
        
   
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            minDate.second! -= 1
            
            if minDate.second == -1 {
                minDate.second = 59
                minDate.minute! -= 1
            }
            if minDate.minute == -1 {
                minDate.minute = 59
                minDate.hour! -= 1
            }
            if minDate.hour == -1 {
                mainview.timelabel.text = "캡슐 오픈"
                timer.invalidate()
            }
            
            let time = String(format: "%02d:", minDate.hour!)+String(format: "%02d:", minDate.minute!)+String(format: "%02d", minDate.second!)

            if minDate.month != 0 { // 7개월 3일 12:03:02
                mainview.dayLabel.text = "\(minDate.month!)개월 \(minDate.day!)일 "
                mainview.timelabel.text = time
            }
            else if minDate.day != 0 {
                mainview.dayLabel.text = "\(minDate.day!)일"
                mainview.timelabel.text = time
            }
            else if minDate.hour != -1 {
                mainview.dayLabel.text = "내일 오픈 가능"
                mainview.timelabel.text = time
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapping =  UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapShowButtonClicked))
        let list = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(listClicked))
        let setting = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingClicked))
        self.navigationItem.leftBarButtonItem = mapping
        self.navigationItem.rightBarButtonItems = [setting,list]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        notificationCenter.delegate = self
        requestAuthorization()
        sendNotification()

        mainview.plusButton.addTarget(self, action: #selector(plusClicked), for: .touchUpInside)
        
    }
    @objc func plusClicked() {
        let vc = WriteViewController()
        transition(vc,transitionStyle: .push)
    }
    
    @objc func listClicked() {
        let vc = ListViewController()
        transition(vc,transitionStyle: .presentFullNavigation)
    }
    @objc func settingClicked() {
        let vc = SettingViewController()
        transition(vc,transitionStyle: .presentFullNavigation)
    }
    
    //MARK: notification 2. 권한요청
    func requestAuthorization(){
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)
        
        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func sendNotification(){
        
        DispatchQueue.main.async { [self] in
            tasks = repository.localRealm.objects(EggTime.self)
            
            tasks.forEach {
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "오늘은 오픈일입니다."
                //                notificationContent.subtitle = "\($0.regDate)에 등록한 타임캡슐이 오픈할수있습니다. "
                print($0.openDate)
                let regDateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: $0.regDate)
                notificationContent.body = "\(regDateComponents.year!)년\(regDateComponents.month!)\(regDateComponents.day!)에 등록한 타임캡슐이 오픈할수있습니다. "
                
                var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: $0.openDate)
                
                print(dateComponents)

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: "sani", content: notificationContent, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    print(error)
                }
            }
        }
    }
}

extension MainViewController {
    // 지도보기 버튼
    @objc func mapShowButtonClicked() {
        let vc = MapViewController()
        transition(vc,transitionStyle: .push)
    }
    
}


extension MainViewController: CLLocationManagerDelegate,UNUserNotificationCenterDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "lat")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "lng")
        }

//        locationManager.stopUpdatingLocation() // stopUpdatingHeading 이랑 주의

    }

}

