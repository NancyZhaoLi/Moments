//
//  VideoItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class VideoItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class VideoItemManager : ItemManager {
    
    override init() {
        super.init()
        self.type = ItemType.Audio
        self.debugPrefix = "[VideoItemManager] -"
    }
    
    func addVideo(video: MPMediaItem, location: CGPoint) {
        if let url = video.assetURL {
            let videoPlayer = AVPlayer(URL: url)
            let videoItemVC = AVPlayerViewController()
            videoItemVC.player = videoPlayer
            
            videoItemVC.view.frame = CGRectMake(location.x, location.y, 100, 80)
            self.canvas!.view.addSubview(videoItemVC.view)
            self.canvas!.addChildViewController(videoItemVC)
        }
    }
}
