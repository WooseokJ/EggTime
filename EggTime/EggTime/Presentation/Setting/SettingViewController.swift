

import UIKit

class SettingViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let settingview = SettingView()
    
    override func loadView() {
        super.view = settingview
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "설정"
        let attributes = [
            NSAttributedString.Key.foregroundColor: AllColor.textColor.color,
            NSAttributedString.Key.font: AllFont.font.name
        ]
        //2
        navigationController?.navigationBar.titleTextAttributes = attributes

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        self.navigationItem.backBarButtonItem = backBarButtonItem

        let list = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(listClicked))
        let home = UIBarButtonItem(image: UIImage(systemName: "house"), style: .plain, target: self, action: #selector(homeClicked))
        self.navigationItem.rightBarButtonItems = [list, home ]
        let mapping =  UIBarButtonItem(image: UIImage(systemName: "map"), style: .plain, target: self, action: #selector(mapShowButtonClicked))
        self.navigationItem.leftBarButtonItem = mapping
        settingview.tableView.dataSource = self
        settingview.tableView.delegate = self
//        let sortButton = UIBarButtonItem(title: "", image: UIImage(systemName: "list.bullet.circle"), primaryAction: nil, menu: self.sortMenu)
//        self.navigationItem.rightBarButtonItems = [sortButton]
        

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


