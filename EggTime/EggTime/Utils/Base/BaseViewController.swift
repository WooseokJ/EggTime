
import UIKit
import RealmSwift

class BaseViewController: UIViewController {
    
    let back = BaseView()
    override func loadView() {
        super.view = back
    }
    
    // 정렬메뉴 액션
//    var menuSortedItems: [UIAction] {
//        return [
//            UIAction(title: "Main", image: UIImage(systemName: "m.circle"), handler: { [self] _ in
//                let vc = MainViewController()
//                transition(vc,transitionStyle: .presentFullNavigation)
//            }),
//            UIAction(title: "List", image: UIImage(systemName: "list.bullet.below.rectangle"), handler: { [self] _ in
//                let vc = ListViewController()
//                transition(vc,transitionStyle: .presentFullNavigation)
//            }),
//            UIAction(title: "Setting", image: UIImage(systemName: "gear.circle"), handler: { [self] _ in
//                let vc = SettingViewController()
//                transition(vc,transitionStyle: .presentFullNavigation)
//            })
//        ]
//    }
//    // 정렬메뉴
//    var sortMenu: UIMenu {
//        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuSortedItems)
//    }
//
    let repository = RealmRepository()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        
        
        navigationController?.navigationBar.tintColor = .white // 좌우측 네비바 버튼 칼러
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white] //네비바 title 칼러
        
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
