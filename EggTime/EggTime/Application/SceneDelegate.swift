//
//  SceneDelegate.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if !UserDefaults.standard.bool(forKey: "first") {
            if let windowScene = scene as? UIWindowScene {
               let window = UIWindow(windowScene: windowScene)
               window.rootViewController = PageViewController()
               UITabBar.appearance().barTintColor = UIColor.white // 처음 탭바 칼러 (스크롤해도 안변해)
               self.window = window
               window.makeKeyAndVisible()
           }
        }
        else {
//            if let windowScene = scene as? UIWindowScene {
//               let window = UIWindow(windowScene: windowScene)
//               window.rootViewController = MainViewController()
//               UITabBar.appearance().barTintColor = UIColor.white // 처음 탭바 칼러 (스크롤해도 안변해)
//               self.window = window
//               window.makeKeyAndVisible()
//           }
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(windowScene: windowScene)
            
            let mainViewController = MainViewController() // 이 뷰컨트롤러를 내비게이션 컨트롤러에 담아볼게요!
            
            let navigationController = UINavigationController(rootViewController: mainViewController) // 내비게이션 컨트롤러에 처음으로 보여질 화면을 rootView로 지정해주고!
                   
           window?.rootViewController = navigationController // 시작을 위에서 만든 내비게이션 컨트롤러로 해주면 끝!
           window?.makeKeyAndVisible()
        }
        

        
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
 
    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
 
    }


}

