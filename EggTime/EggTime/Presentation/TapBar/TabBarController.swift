
import Foundation
import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false


        let firstVC = UINavigationController(rootViewController: MainViewController())
        firstVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        firstVC.tabBarItem.title = "house"
        firstVC.tabBarItem.image = UIImage(systemName: "house")

        let secondVC =  UINavigationController(rootViewController: MapViewController())
        secondVC.view.backgroundColor = .clear
        secondVC.tabBarItem.selectedImage = UIImage(systemName: "map.circle.fill")
        secondVC.tabBarItem.title = "map"
        secondVC.tabBarItem.image = UIImage(systemName: "map.circle")

        viewControllers = [firstVC, secondVC]

    }

}


