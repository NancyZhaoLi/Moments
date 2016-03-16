//
//  VideoItemManager.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-09.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import AVKit
import AVFoundation


class VideoItemManager : ItemManager {
    
    var videoItems : [VideoItemViewController] = [VideoItemViewController]()
    
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
    
    func loadVideo(videoItem: VideoItemEntry) -> VideoItemViewController {
        return VideoItemViewController()
    }
    
    override func saveAllItemEntry() {

    }
    
    override func setEditMode(editMode: Bool) {
        for videoItem in videoItems {
            videoItem.view.userInteractionEnabled = editMode
        }
    }
    
}