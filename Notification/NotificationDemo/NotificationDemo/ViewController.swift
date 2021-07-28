//
//  ViewController.swift
//  NotificationDemo
//
//  Created by Developer on 01/06/2021.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var lb_text: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lb_text.text = ""
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.listenNotification = { (result) in
            self.lb_text.text = String(result)
        }
        
    }

  

   
}

