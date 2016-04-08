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

class VideoItemView: UIImageView {
    private var playImageTitle = "play2_icon.png"
    private var buttonSize: CGFloat = 80.0
    
    var fileURL: NSURL?
    
    init() {
        super.init(frame: CGRectZero)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func setFileURL(fileURL url: NSURL) {
        self.fileURL = url
        setSnapShot()
    }
    
    
    func loadVideo(fileURL url: NSURL, frame: CGRect, zPosition: Int, snapshot: UIImage?) {
        self.fileURL = url
        self.image = snapshot
        self.frame = frame
        self.layer.zPosition = CGFloat(zPosition)
    }
    
    private func setSnapShot() {
        if let fileURL = self.fileURL {
            let asset = AVAsset(URL: fileURL)
            let assetImageGen = AVAssetImageGenerator(asset: asset)
            assetImageGen.appliesPreferredTrackTransform = true
            var time = asset.duration
            time.value = min(time.value, 1)
            
            do {
                var snapshot = try UIImage(CGImage: assetImageGen.copyCGImageAtTime(time, actualTime: nil))
            
                // Resize and rotate the Snapshot
                let defaultMaxDimension: CGFloat = 250.0
                let imageMaxDimension:CGFloat = max(snapshot.size.height, snapshot.size.width)
                var resizeRatio: CGFloat = 1.0
                
                if imageMaxDimension > defaultMaxDimension {
                    resizeRatio = imageMaxDimension/defaultMaxDimension
                }
                
               /* if snapshot.size.width < snapshot.size.height {
                    if let snapshotCG = snapshot.CGImage {
                        snapshot = UIImage(CGImage: snapshotCG, scale: 1.0, orientation: UIImageOrientation.Right)
                    }
                }*/

                let newWidth = snapshot.size.width/resizeRatio
                let newHeight = snapshot.size.height/resizeRatio
                snapshot = UIHelper.resizeImage(snapshot, newWidth: newWidth, newHeight: newHeight)
                
                //Add play button to snapshot
                UIGraphicsBeginImageContext(snapshot.size)
                let snapshotRect = CGRectMake(0,0,snapshot.size.width, snapshot.size.height)
                let playButtonRect = CGRectMake(snapshot.size.width/2.0 - buttonSize/2.0, snapshot.size.height/2.0 - buttonSize/2.0, buttonSize, buttonSize)
                let playButton = UIHelper.resizeImage(UIImage(named: playImageTitle)!, newWidth: buttonSize)
                snapshot.drawInRect(snapshotRect)
                playButton.drawInRect(playButtonRect)
                
                snapshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                // Set the frame size to resized snapshot size
                let frame = CGRectMake(0,0, newWidth, newHeight)
                self.frame = frame
                self.bounds = frame
                self.image = snapshot
            } catch{}
        }
    }
    
    func setLocation(location: CGPoint) {
        self.center = location
    }
}


class VideoItemViewController: ItemViewController, AVPlayerViewControllerDelegate {
    
    var playerVC: AVPlayerViewController?
    var videoView: VideoItemView = VideoItemView()
    
    override init?(manager: NewMomentManager?) {
        super.init(manager: manager)
        self.view = videoView
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func addItem (videoURL url: NSURL, location: CGPoint) {
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(URL: url)
        
        self.playerVC = playerVC
        videoView.setFileURL(fileURL: url)
        videoView.setLocation(location)
        addToCanvas()
        addGR()
    }

    override func addItem(video video: VideoItem) {
        if let url = video.getURL() {
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(URL: url)
            
            self.playerVC = playerVC
            videoView.loadVideo(fileURL: url, frame: video.getFrame(), zPosition: video.getZPosition(), snapshot: video.getSnapshot())
            addToCanvas(video.getZPosition())
            addGR()
        }
    }
    
    /*********************************************************************************
     
     GESTURE RECOGNIZERS
     
     *********************************************************************************/
    
    var tapToPlayGR: UITapGestureRecognizer?
    
    override func addGR() {
        super.addGR()
        addTapToPlayGR()
    }
    
    private func addTapToPlayGR() {
        let tapToPlayGR = UITapGestureRecognizer(target: self, action: "play")
        if let manager = self.manager {
            tapToPlayGR.enabled = manager.enableInteraction
        }
        self.view.addGestureRecognizer(tapToPlayGR)
        self.tapToPlayGR = tapToPlayGR
    }

    override func addRotateGR() {}

    override func enableTrash(enabled: Bool) {
        super.enableTrash(enabled)
        tapToPlayGR?.enabled = !enabled
    }
    
    override func tapToTrash(sender: UITapGestureRecognizer) {
        super.tapToTrash(sender)
    }
    
    func play() {
        if let playerVC = self.playerVC {
            presentViewController(playerVC, animated: true, completion: nil)
            if let player = playerVC.player {
                player.play()
            } else {
                print("no video player")
            }
        } else {
            print("no video player vc")
        }
    }
}
