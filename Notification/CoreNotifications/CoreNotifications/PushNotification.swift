//
//  PushNotification.swift
//  CoreNotifications
//
//  Created by Developer on 04/06/2021.
//

import Foundation
import UserNotifications
import Firebase
import Messages

open class PushNotification :NSObject {
    
    public static let shared = PushNotification()
  
    public typealias listen = (String)->()
    
    public enum ActionList {
        case Accept
        case Deny
    }
    
    public var listenMess:listen = { value in }
    
    public func registerPush(_ application: UIApplication){
        UNUserNotificationCenter.current().delegate = self
        configureNotification()
        configApplePush(application)
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
    }
    
   public func setActionCategories(catelogy:UNNotificationCategory? = nil){
   
    if catelogy == nil {
        let acceptAction = UNNotificationAction(
        identifier: "\(ActionList.Accept)",
        title: "Apcept",
        options: [.foreground])

        let denyAction = UNNotificationAction(
        identifier: "\(ActionList.Deny)",
        title: "Deny",
        options: [.foreground])

        let acceptCategory = UNNotificationCategory(
        identifier: "core_notification",
        actions: [acceptAction, denyAction],
        intentIdentifiers: [],
        options: [])
   
        UNUserNotificationCenter.current().setNotificationCategories([acceptCategory])
        }
    else {
        UNUserNotificationCenter.current().setNotificationCategories([catelogy!])
    }
  }
     
    func configureNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            center.delegate = self
            let openAction = UNNotificationAction(identifier: "OpenNotification", title: NSLocalizedString("Abrir", comment: ""), options: UNNotificationActionOptions.foreground)
            let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction], intentIdentifiers: [], options: [])
            center.setNotificationCategories(Set([deafultCategory]))
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
    }

    
    func configApplePush(_ application: UIApplication) {
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            application.registerForRemoteNotifications()
            
            if let token = Messaging.messaging().fcmToken {
                print("FCM token: \(token)")
               
            }
        }
  
}

@available(iOS 10, *)
extension PushNotification : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    completionHandler([[.alert, .sound]])
  }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    
            listenMess("\(response.actionIdentifier)")
            completionHandler()
  }
}

extension PushNotification : MessagingDelegate {

    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
    
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
  }

}
