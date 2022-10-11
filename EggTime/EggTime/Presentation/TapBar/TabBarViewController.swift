
import Foundation
import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false
        
        let firstVC = UINavigationController(rootViewController: MainViewController())
        firstVC.tabBarItem.selectedImage = UIImage(systemName: "timer")
        firstVC.tabBarItem.title = "timer"
        firstVC.tabBarItem.image = UIImage(systemName: "timer")
        
        let secondVC =  UINavigationController(rootViewController: MapViewController())
        secondVC.view.backgroundColor = .clear
        secondVC.tabBarItem.selectedImage = UIImage(systemName: "map.circle.fill")
        secondVC.tabBarItem.title = "map"
        secondVC.tabBarItem.image = UIImage(systemName: "map.circle")
        
        let thirdVC = UINavigationController(rootViewController: ListViewController())
        thirdVC.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.indent")
        thirdVC.tabBarItem.title = "List"
        thirdVC.tabBarItem.image = UIImage(systemName: "list.dash")
        
        viewControllers = [firstVC, secondVC, thirdVC]
        
    }


}
