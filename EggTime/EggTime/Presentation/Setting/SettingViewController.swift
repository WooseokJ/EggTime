

import UIKit

class SettingViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let settingview = SettingView()
    
    override func loadView() {
        super.view = settingview
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "설정"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        
        
        self.navigationItem.backBarButtonItem = backBarButtonItem
        settingview.tableView.dataSource = self
        settingview.tableView.delegate = self



    }
    @objc func listClicked() {
        let vc = ListViewController()
        transition(vc,transitionStyle: .presentFullNavigation)
    }
    @objc func homeClicked() {
        let vc = MainViewController()
        transition(vc,transitionStyle: .presentFullNavigation)
    }
    // 지도보기 버튼
    @objc func mapShowButtonClicked() {
        let vc = MapViewController()
        transition(vc,transitionStyle: .push)
    }


}


