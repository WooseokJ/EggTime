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

        
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(windowScene: windowScene)
            let mainViewController = TabBarController() // 이 뷰컨트롤러를 내비게이션 컨트롤러에 담아볼게요!
           window?.rootViewController = mainViewController // 시작을 위에서 만든 내비게이션 컨트롤러로 해주면 끝!
           window?.makeKeyAndVisible()

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


