//
//  AppDelegate.swift
//  CoreNotificationsTest
//
//  Created by Developer on 04/06/2021.
//

import UIKit
import Firebase
import CoreNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var listenNotification =  {(result:String) in }

    public enum ActionList {
        case Accept
        case Deny
        case Other
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        PushNotification.shared.registerPush(application)
        setActionListNotification()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
      print("APNs device token: \(deviceTokenString)")
    }
    
    func setActionListNotification(){
        let acceptAction = UNNotificationAction(
        identifier: "\(ActionList.Accept)",
        title: "Apcept",
        options: [.foreground])

        let denyAction = UNNotificationAction(
        identifier: "\(ActionList.Deny)",
        title: "Deny",
        options: [.foreground])
        
        let otherAction = UNNotificationAction(
        identifier: "\(ActionList.Other)",
        title: "Other",
        options: [.foreground])

        let acceptCategory = UNNotificationCategory(
        identifier: "core_category",
        actions: [acceptAction, denyAction,otherAction ],
        intentIdentifiers: [],
        options: [])
        PushNotification.shared.setActionCategories(catelogy: acceptCategory)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
        PushNotification.shared.listenMess = { result in
            self.listenNotification(result)
        }
       // listenNotification("\(userInfo["value"] ?? "")")
        
    }

}

