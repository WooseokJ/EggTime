

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
    var tasks: Results<EggTime>!

    private var timer: Timer?
    private let date = Date()
    
    private let notificationCenter = UNUserNotificationCenter.current()

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "홈"

        EggCheck()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingClicked))
        notificationCenter.delegate = self
        requestAuthorization()
        mainview.plusButton.addTarget(self, action: #selector(plusClicked), for: .touchUpInside)
    }
    
    func EggCheck() {
        tasks = repository.fetch()
        guard !tasks.isEmpty else {
            mainview.EggHidden()
            return
        }

        let nearTime = repository.nearTimeFetch()
        let minDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: nearTime[0].openDate)
        
        guard var hour = minDate.hour else{return}
        guard var minute = minDate.minute else{return}
        guard var second = minDate.second else{return}
        guard var month = minDate.month else{return}
        guard var day = minDate.day else{return}
        
        if timer != nil && timer!.isValid {
            timer?.invalidate() //기존 타이머 시작하면 멈춤
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            second -= 1
            
            if second == -1 {
                second = 59
                minute -= 1
            }
            if minute == -1 {
                minute = 59
                hour -= 1
            }
            if hour < 0 {
                timer.invalidate()
            }
            mainview.timerLabel.text = String(format: "%02d:", hour)+String(format: "%02d:", minute)+String(format: "%02d", second)
            mainview.writerLabel.text = "\(nearTime[0].title)님이 묻은 타임캡슐 "
            
            if minDate.month! > 0 {
                mainview.leaveDay.text = "\(month)개월 \(day)일 "
            }
            else if minDate.day! > 0 {
                mainview.leaveDay.text = "\(day)일"
            }
            else if (hour > 0) && (minute > 0 ) && (second > 0 ) {
                mainview.leaveDay.text = "오늘 자정 오픈"
            } else {
                mainview.leaveDay.text = ""
            }
            mainview.EggShow()

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
                
                guard let year = regDateComponents.year else {return}
                guard let month = regDateComponents.month else {return}
                guard let day = regDateComponents.day else {return}
                
                notificationContent.body = "\(year)년\(month)월\(day)일에 등록한 타임캡슐이 오픈할수있습니다."
                
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

extension MainViewController {
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
}
