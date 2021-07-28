//
//  ViewController.swift
//  CoreNotificationsTest
//
//  Created by Developer on 04/06/2021.
//

import UIKit
import CoreNotifications

class ViewController: UIViewController {

    
    
    @IBOutlet weak var lb_value: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.listenNotification = { (reslt) in
            self.lb_value.text = String(reslt)
        }
      
    }

}

