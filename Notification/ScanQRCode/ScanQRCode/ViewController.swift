//
//  ViewController.swift
//  ScanQRCode
//
//  Created by Developer on 14/06/2021.
//

import UIKit

class ViewController: UIViewController {

 
    @IBOutlet weak var tf_value: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }

    @IBAction func bt_scanTap(_ sender: Any) {
        let vc = ScanQRViewController()
        present(vc, animated: true, completion: nil)
        vc.scanResult = { [self] result in
            tf_value.text = result
        }
    
    }
    
}


