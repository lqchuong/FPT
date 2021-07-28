//
//  CustomNotificationViewController.swift
//  NotificationDemo
//
//  Created by Developer on 02/06/2021.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class CustomNotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @available(iOSApplicationExtension 10.0, *)
       func didReceive(_ notification: UNNotification) {
           let content = notification.request.content

           if let urlImageString = content.userInfo["urlImageString"] as? String {
               if let url = URL(string: urlImageString) {
                   URLSession.downloadImage(atURL: url) { [weak self] (data, error) in
                       if let _ = error {
                           return
                       }
                       guard let data = data else {
                           return
                       }
                       DispatchQueue.main.async {
                           self?.imgView.image = UIImage(data: data)
                       }
                   }
               }
           }
       }
       
   }

   extension URLSession {
       
       class func downloadImage(atURL url: URL, withCompletionHandler completionHandler: @escaping (Data?, NSError?) -> Void) {
           let dataTask = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
               completionHandler(data, nil)
           }
           dataTask.resume()
       }
   }
