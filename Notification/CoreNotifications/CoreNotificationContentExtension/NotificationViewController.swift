//
//  NotificationViewController.swift
//  CoreNotificationContentExtension
//
//  Created by Developer on 05/06/2021.
//


import UIKit
import AVKit
import UserNotifications
import UserNotificationsUI
import youtube_ios_player_helper
 
class NotificationViewController: UIViewController, UNNotificationContentExtension, YTPlayerViewDelegate {
 
   
    @IBOutlet weak var lb_description: UILabel!
    @IBOutlet weak var img_notification: UIImageView!
    @IBOutlet var label: UILabel?
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_videoTitle: UILabel!
    
    @IBOutlet weak var tf_comment: UITextView!
    @IBOutlet weak var bt_deny: UIButton!
    @IBOutlet weak var bt_submit: UIButton!
    
//    @IBOutlet weak var lb_videoDescription: UILabel!
//
    typealias deny = (Bool)->()
    var clickButton:deny = { result in }
    
    var playerController: AVPlayerViewController!
   
    var isSubmit = false {
        didSet {
            self.bt_submit.tintColor = self.isSubmit ? UIColor.systemGray : UIColor.systemBlue
            self.bt_submit.setTitle(self.isSubmit ? " Submited" : " Submit", for: .normal)
        }
    }

    var isDeny = false {
        didSet {
            self.bt_deny.tintColor = self.isDeny ? UIColor.systemGray : UIColor.systemBlue
            self.bt_deny.setTitle(self.isDeny ? " Denied" : " Deny", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any required interface initialization here.
    }
    
   
    
    func didReceive(_ notification: UNNotification) {
       
      
        self.lb_title?.text = notification.request.content.userInfo["title"] as? String
        self.lb_description?.text = notification.request.content.userInfo["description"] as? String
        self.label?.text = notification.request.content.userInfo["body"] as? String
        self.lb_videoTitle?.text = notification.request.content.userInfo["video_title"] as? String
        let attachmentURL = notification.request.content.userInfo["image_title"] as? String
        if attachmentURL != nil {
            let data = try? Data(contentsOf: URL(string: attachmentURL ?? "https://example.default.image/image.png")!)
            if data != nil {
                self.img_notification.image = UIImage(data: data!)
            }
        }
        guard let videoId = notification.request.content.userInfo["video_id"] as? String else {
            return
        }
        let player = YTPlayerView(frame: CGRect(x: 0,y: 0,width: playerView.frame.width , height: playerView.frame.height))
            let dict = ["modestbranding" : 0,"controls" : 1,"autoplay" : 1,"playsinline" : 1,"autohide" : 1,"showinfo" : 0]
        player.load(withVideoId: videoId ,playerVars: dict)
            player.delegate = self
        playerView.addSubview(player)
    }
  
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()

    }
    
    @IBAction func bt_denyClick(_ sender: Any) {
        
//        self.isDeny.toggle()
        clickButton(false)
      
    }
    
    @IBAction func bt_submitClick(_ sender: Any) {
//        self.isSubmit.toggle()
        clickButton(true)
        
    }
}

