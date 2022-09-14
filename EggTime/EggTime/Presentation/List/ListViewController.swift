

import UIKit
import RealmSwift

class ListViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let listView = ListView()
    override func loadView() {
        super.view = listView
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "캡슐 리스트"
        listView.collectionview.dataSource = self
        listView.collectionview.delegate = self
    }
    
    
    let repository = RealmRepository()
    var tasks: Results<EggTime>! {
        didSet {
            listView.collectionview.reloadData()
            print("collectionview Tasks Changed")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        tasks = repository.fetch()
    }

}

