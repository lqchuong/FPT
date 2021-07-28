
//
//  AppDelegate.swift
//  NotificationDemo
//
//  Created by Developer on 01/06/2021.
//

import UIKit
import CoreNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    typealias listen = (String)->()
    
    public enum ActionList {
        case Accept
        case Deny
        case Other
    }
    
    var listenNotification:listen = { listening in
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        PushNotification.shared.registerPush(application)
        setActionListNotification()
        return true
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

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
      print("APNs device token: \(deviceTokenString)")
    }

    
   
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        PushNotification.shared.listenMess = { result in
            self.listenNotification(result)
        }
    }
  

 
}

