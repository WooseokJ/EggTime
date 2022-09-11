

import UIKit

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
    

 

}
