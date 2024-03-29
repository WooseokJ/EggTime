

import UIKit
import RealmSwift
import CoreLocation
import SnapKit

final class ListViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let listView = ListView()
    override func loadView() {
        super.view = listView
    }

    override func viewWillAppear(_ animated: Bool) {
        tasks = repository.fetch()
        navigationItem.title = "타임 캡슐 리스트"
        
        guard tasks.isEmpty else {
            listView.EggShow()
            return
        }
        listView.EggHidden()
        listView.contentlabel.text = "현재 묻은 타임캡슐이 없습니다."
    }
    
    var tasks: Results<EggTime>! {
        didSet {
            listView.collectionview.reloadData()
            print("collectionview Tasks Changed")
        }
    }
    
    var openAvailable: [ObjectId] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.collectionview.dataSource = self
        listView.collectionview.delegate = self
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    
    
}

