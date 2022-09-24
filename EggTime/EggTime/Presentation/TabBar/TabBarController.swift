//
//  CustomTabBarController.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = AllColor.background.color
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.backgroundColor = .white
        self.tabBar.isTranslucent = false

        let firstVC = UINavigationController(rootViewController: MainViewController())
        firstVC.tabBarItem.selectedImage = UIImage(systemName: "map.circle.fill")
        firstVC.tabBarItem.title = "Map"
        firstVC.tabBarItem.image = UIImage(systemName: "map.circle")

        let secondVC = UINavigationController(rootViewController: ListViewController())
        secondVC.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.indent")
        secondVC.tabBarItem.title = "List"
        secondVC.tabBarItem.image = UIImage(systemName: "list.dash")


        let thirdVC =  UINavigationController(rootViewController: SettingViewController())
        thirdVC.view.backgroundColor = .blue
        thirdVC.tabBarItem.selectedImage = UIImage(systemName: "gear.badge.checkmark")
        thirdVC.tabBarItem.title = "Setting"
        thirdVC.tabBarItem.image = UIImage(systemName: "gear.badge.questionmark")

        viewControllers = [firstVC, secondVC, thirdVC]

    }


}
