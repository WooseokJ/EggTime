

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
        navigationItem.title = "타임 캡슐 묻기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(mapShowButtonClicked))

        
        mainview.soakButton.addTarget(self, action: #selector(soakButtonClicked), for: .touchUpInside)
    }
        
    
}



extension MainViewController {
    
    
    @objc func soakButtonClicked() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let soakButton = UIAlertAction(title: "타임 캡슐 묻기", style: .default) { (action) in
            self.tapsoakButton()
        }
        let modifyButton = UIAlertAction(title: "수정하기", style: .default) { (action) in
            self.tapModifyButton()
        }
        let cancel = UIAlertAction(title: "취소하기", style: .cancel)
        
        alert.addAction(soakButton)
        alert.addAction(modifyButton)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    func tapsoakButton(){
        let vc = WriteViewController()
        transition(vc,transitionStyle: .push)
        vc.select = true


    }
    
    func tapModifyButton() {
        let vc = WriteViewController()
        transition(vc,transitionStyle: .push)
        vc.select = false
    }
    
    // 지도보기 버튼
    @objc func mapShowButtonClicked() {
        let vc = MapViewController()
        transition(vc,transitionStyle: .push)
    }
 
}
