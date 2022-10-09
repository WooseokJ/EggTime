
import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.backgroundColor = .clear
        self.tabBar.isTranslucent = false
        
        let firstVC = UINavigationController(rootViewController: MainViewController())
        firstVC.tabBarItem.selectedImage = UIImage(systemName: "timer")
        firstVC.tabBarItem.title = "timer"
        firstVC.tabBarItem.image = UIImage(systemName: "timer")
        
        let secondVC = UINavigationController(rootViewController: ListViewController())
        secondVC.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.indent")
        secondVC.tabBarItem.title = "List"
        secondVC.tabBarItem.image = UIImage(systemName: "list.dash")
        
        
        let thirdVC =  UINavigationController(rootViewController: MapViewController())
        thirdVC.view.backgroundColor = .blue
        thirdVC.tabBarItem.selectedImage = UIImage(systemName: "map.circle.fill")
        thirdVC.tabBarItem.title = "map"
        thirdVC.tabBarItem.image = UIImage(systemName: "map.circle")
        
        viewControllers = [firstVC, thirdVC, secondVC]
        
    }


}
