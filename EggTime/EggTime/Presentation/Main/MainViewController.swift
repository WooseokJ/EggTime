

import UIKit
import SnapKit


class MainViewController: BaseViewController {
    
    //MARK: 뷰 가져오기
    let mainview = MainView()
    
    override func loadView() {
        super.view = mainview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "타임 캡슐 묻기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(mapShowButtonClicked))

    }
        
    
}



extension MainViewController {
    
    
    // 지도보기 버튼
    @objc func mapShowButtonClicked() {
        let vc = MapViewController()
        transition(vc,transitionStyle: .push)
    }
 
}
