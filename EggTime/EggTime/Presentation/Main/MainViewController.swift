

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
    var second: Int = 0
    let date = Date()
        
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        navigationItem.title = "타임 캡슐"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]

        let date = Date()

        let min = repository.localRealm.objects(EggTime.self).filter("openDate >= %@",date).sorted(byKeyPath: "openDate", ascending: true)

        
        guard !min.isEmpty else {
            
            mainview.titleLabel.text = "캡슐 없음"
            return
        }
      
        
        
        mainview.titleLabel.text = min[0].title
        
        mainview.tempLabel.text = "가장 빠른 캡슐 남은기간"

        var minDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: min[0].openDate)
        
        print(minDate)
        
        if timer != nil && timer!.isValid {
            timer?.invalidate() //기존 타이머 시작하면 멈춤
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
                mainview.dayLabel.text = "오늘"
                mainview.timelabel.text = time
            }
        }
      
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortButton = UIBarButtonItem(title: "", image: UIImage(systemName: "list.bullet.circle"), primaryAction: nil, menu: self.sortMenu)
        let mapping =  UIBarButtonItem(image: UIImage(systemName: "map.circle"), style: .plain, target: self, action: #selector(mapShowButtonClicked))
        self.navigationItem.rightBarButtonItems = [sortButton,mapping]
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    
    
}

extension MainViewController {
    // 지도보기 버튼
    @objc func mapShowButtonClicked() {
        let vc = MapViewController()
        transition(vc,transitionStyle: .push)
    }
    
}


