

import UIKit
import SnapKit
import RealmSwift

class MainViewController: BaseViewController, UNUserNotificationCenterDelegate {
    
    //MARK: 뷰 가져오기
    let mainview = MainView()
    override func loadView() {
        super.view = mainview
    }
    let repository = RealmRepository()
    var tasks: Results<EggTime>! {
        didSet {
            print("collectionview Tasks Changed")
        }
    }
    let notificationCenter = UNUserNotificationCenter.current() // 알람할떄 선행되야됨.
    override func viewWillAppear(_ animated: Bool) {

        navigationItem.title = "타임 캡슐"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: UIFont(name: "SongMyung-Regular", size:16)!
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortButton = UIBarButtonItem(title: "", image: UIImage(systemName: "list.bullet.circle"), primaryAction: nil, menu: self.sortMenu)
        let mapping =  UIBarButtonItem(image: UIImage(systemName: "map.circle"), style: .plain, target: self, action: #selector(mapShowButtonClicked))
        self.navigationItem.rightBarButtonItems = [sortButton,mapping]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        notificationCenter.delegate = self
        requestAuthorization()
        
        

    }
    //MARK: notification 2. 권한요청
    func requestAuthorization(){
        let authrozationOptions = UNAuthorizationOptions(arrayLiteral: .alert, .sound)
        notificationCenter.requestAuthorization(options: authrozationOptions){success,error in
            if success{
                self.sendNotification()
            }
        }
    }
    
    func sendNotification(){
        
        DispatchQueue.main.async { [self] in
            tasks = repository.localRealm.objects(EggTime.self)
            
            tasks.forEach {
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "오늘은 오픈일입니다."
                notificationContent.subtitle = "subtitle"
                notificationContent.body = "body"
                
                
                
                
//                var date = DateComponents()
//                date.hour = 8
//                date.minute = 30
                let date = Date().addingTimeInterval(10)
                let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
//                var dateComponents = calendar.dateComponents([.year, .month, .day], from: $0.openDate)
//                print(dateComponents)
//                print(Date())
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: "\($0.openDate)", content: notificationContent, trigger: trigger)
                notificationCenter.add(request) //등록시 시간,날짜 계속체크 앱이꺼져도
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
