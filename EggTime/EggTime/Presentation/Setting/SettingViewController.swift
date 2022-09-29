

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
        
        settingview.tableView.dataSource = self
        settingview.tableView.delegate = self
        let sortButton = UIBarButtonItem(title: "", image: UIImage(systemName: "list.bullet.circle"), primaryAction: nil, menu: self.sortMenu)
        self.navigationItem.rightBarButtonItems = [sortButton]

    }
    

}


