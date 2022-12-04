//
//  AppDelegate.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/07.
//

import UIKit
import FirebaseCore
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert], completionHandler: { (granted,error) in })
        application.registerForRemoteNotifications()

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        }
//        } else {
//          let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//        }

        application.registerForRemoteNotifications()
        
        //메세지 대리자 설정
        Messaging.messaging().delegate = self
        
        //등록된 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserDefaultsManager.shared.setValue(value: token, type: .fcmToken)
                print("토큰왔잖아 \(UserDefaultsManager.shared.fetchValue(type: .fcmToken))")
            }
        }
        
        UINavigationBar.appearance().tintColor = .black
        
        print(UserDefaultsManager.shared.fetchValue(type: .idToken) as? String ?? "")
        
        //MARK: 네비게이션 백버튼
        let backButtonImage = UIImage(named: ImageName.backButton)
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        guard let fcmToken else { return }
        UserDefaultsManager.shared.setValue(value: fcmToken, type: .fcmToken)
        print(UserDefaultsManager.shared.fetchValue(type: .fcmToken))
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}

