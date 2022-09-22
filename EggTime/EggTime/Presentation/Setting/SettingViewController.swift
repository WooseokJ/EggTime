

import UIKit

class SettingViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let settingview = SettingView()
    
    override func loadView() {
        super.view = settingview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "설정"
        settingview.tableView.dataSource = self
        settingview.tableView.delegate = self
        let sortButton = UIBarButtonItem(title: "", image: UIImage(systemName: "list.bullet.circle"), primaryAction: nil, menu: self.sortMenu)
        self.navigationItem.rightBarButtonItems = [sortButton]

    }
    

}


