
import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        view.backgroundColor = Constants.background.color
        TabBarController().tabBar.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .white // 좌우측 네비바 버튼 칼러
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white] //네비바 title 칼러
         
    }
    
    func configure() {}
    func setConstraints() {}
    
    func showAlertMessage(title: String, button: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert,animated: true)
    }

    


}
