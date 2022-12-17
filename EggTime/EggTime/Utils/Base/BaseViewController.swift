
import UIKit
import RealmSwift

class BaseViewController: UIViewController {
    
    let back = BaseView()
    override func loadView() {
        super.view = back
    }
    
    let repository = RealmRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 모든 네비바 글자및아이콘 컬러
        navigationController?.navigationBar.tintColor = .white
        
        // 네비게이션 타이틀 폰트및 색상 적용
        let attributes = [
            NSAttributedString.Key.foregroundColor: AppColor.textColor.color,
            NSAttributedString.Key.font: AppFont.font.name
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        
    }
    
    func showAlertMessage(title: String, button: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert,animated: true)
    }
    
    
    
    
}
