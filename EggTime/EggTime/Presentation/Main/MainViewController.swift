

import UIKit
import SnapKit
import RealmSwift
import UserNotifications
import CoreLocation

final class MainViewController: BaseViewController {
    
    //MARK: 뷰 가져오기
    private let mainview = MainView()
    override func loadView() {
        super.view = mainview
    }
    
    private var timer: Timer?
    private let date = Date()
    
    private let locationManager = CLLocationManager()
    private let notificationCenter = UNUserNotificationCenter.current()

    override func viewWillAppear(_ animated: Bool) {
        // 위치정보 여부 묻기
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else{print("위치 서비스 Off 상태")}
        navigationItem.title = "홈"
        let nearTime = repository.nearTimeFetch()

        guard !nearTime.isEmpty else {
            notExistCapsule()
            return
        }
        
        existCapsule()
        
        mainview.titleLabel.text = "\(nearTime[0].title)님이 묻은캡슐"
        timeSelect(nearTime: nearTime[0].openDate , mainview: mainview)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뒤로가기 버튼 생성
        let backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        // setting 네비바 버튼 생성
        let setting = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingClicked)) 
        self.navigationItem.rightBarButtonItem = setting
        // 위치정보 델리게이트
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // 노티정보 델리게이트
        notificationCenter.delegate = self
        requestAuthorization()
        // 추가하기 버튼 기능
        mainview.plusButton.addTarget(self, action: #selector(plusClicked), for: .touchUpInside)
    }
    //MARK: 캡슐 추가하기
    @objc func plusClicked() {
        let vc = WriteViewController()
        transition(vc,transitionStyle: .push)
    }
    //MARK: setting 추가하기
    @objc func settingClicked() {
        let vc = SettingViewController()
        transition(vc,transitionStyle: .push)
    }
    //MARK: 캡슐이 아무것도 없을떄
    func notExistCapsule() {
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
        mainview.tempLabel.text = "현재 오픈대기중인 캡슐이 없습니다."
        
    }
    //MARK: 캡슐이 존재할떄
    func existCapsule() {
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
        mainview.tempLabel.text = "가장 빨리 열수있는 캡슐까지 남은기간"
    }
    
    func timeSelect(nearTime: Date, mainview: MainView) {
        var minDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: nearTime)

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

            if minDate.month! > 0 { // 7개월 3일 12:03:02
                mainview.dayLabel.text = "\(minDate.month!)개월 \(minDate.day!)일 "
                mainview.timelabel.text = time
            }
            else if minDate.day! > 0 {
                mainview.dayLabel.text = "\(minDate.day!)일"
                mainview.timelabel.text = time
            }
            else if minDate.hour! > 0  {
                mainview.dayLabel.text = "내일 오픈 가능"
                mainview.timelabel.text = time
            }
        }
    }
}

//MARK: 위치정보 관련 매소드
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "lat")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "lng")
        }
    }

}

//MARK: 노티정보 관련 매소드
extension MainViewController: UNUserNotificationCenterDelegate {
    
    //MARK: notification 2. 권한요청
    func requestAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)
        
        notificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
        DispatchQueue.main.async { [self] in
            
            repository.tasks.forEach {
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "오늘은 오픈일입니다."
                let regDateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: $0.regDate)
                notificationContent.body = "\(regDateComponents.year!)년\(regDateComponents.month!)월\(regDateComponents.day!)일에 등록한 타임캡슐이 오픈할수있습니다. "
                
                let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: $0.openDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "sani", content: notificationContent, trigger: trigger)
                notificationCenter.add(request) { (error) in
                    print(error as Any)
                }
            }
        }
    }
}
