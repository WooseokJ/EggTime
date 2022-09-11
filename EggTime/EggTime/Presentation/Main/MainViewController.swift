

import UIKit

class MainViewController: BaseViewController {

    //MARK: 뷰 가져오기
    let mainview = MainView()
    
    override func loadView() {
        super.view = mainview
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "타임 캡슐 묻기"
        
        mainview.soakButton.addTarget(self, action: #selector(soakButtonClicked), for: .touchUpInside)
    }
    
    
    


}

