//
//  AppDelegate.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//
import UIKit
import NMapsMap
import UserNotifications
import FirebaseCore
import FirebaseMessaging
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NMFAuthManager.shared().clientId = "sjtk98rxyn"
        UNUserNotificationCenter.current().delegate = self // viewdidload...
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // 현재 등록된 디바이스 토큰 가져오기
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          }
        }
        
        return true
    
    }
    

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
 
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    // forground일떄 알림오게 해주는 메소드(로컬/푸시 동일)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // .banner, .list 는 ios14 이상부터사용가능( 그이전엔 .alert 이였다)
        completionHandler([.badge,.sound,.banner,.list])
    }
    
    // 푸쉬클릭: 쿠팡 장바구니 담는 화면 전환
    // 유저가 푸시를 클릭시 수신확인가능
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("사용자가 푸시를 클릭함.")
        print(response.notification.request.content.body)
        print(response.notification.request.content.userInfo)
        let userInfo = response.notification.request.content.userInfo
        if userInfo[AnyHashable("sesac")] as? String == "project" { //sesac이라는 키에 project라는 값이있다면?
            print("sesac project ===================================================================")
        } else {
            print("nothing==========================================================================")
        }
    }

}
 

extension AppDelegate: MessagingDelegate {
    // 토큰갱신 모니터링 (선택사항) : 토큰정보가 언제바뀔까?
    // 이걸안하면 ex) 앱은 설치되어있는데 회원탈퇴해도 알림이 계속온다
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
