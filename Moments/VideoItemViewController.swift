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
    private var playImageTitle = "play_icon.png"
    private var buttonSize: CGFloat = 80.0
    
    var fileURL: NSURL?
    var fileSnapshot: UIImage?
    
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
        self.fileSnapshot = snapshot
        self.frame = frame
        self.layer.zPosition = CGFloat(zPosition)
        if let snapshot = snapshot {
            self.backgroundColor = UIColor(patternImage: UIHelper.resizeImage(snapshot, newWidth: frame.size.width, newHeight: frame.size.height))
        }
    }
    
    private func setSnapShot() {
        if let fileURL = self.fileURL {
            let asset = AVAsset(URL: fileURL)
            let assetImageGen = AVAssetImageGenerator(asset: asset)
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
                
                if let snapshotCG = snapshot.CGImage {
                    snapshot = UIImage(CGImage: snapshotCG, scale: 1.0, orientation: UIImageOrientation.Right)
                }

                let newWidth = snapshot.size.width/resizeRatio
                let newHeight = snapshot.size.height/resizeRatio
                snapshot = UIHelper.resizeImage(snapshot, newWidth: newWidth, newHeight: newHeight)
                
                // Set the frame size to resized snapshot size
                let frame = CGRectMake(0,0, newWidth, newHeight)
                self.frame = frame
                self.bounds = frame
                
                // Add the play button
                let playerButton = ButtonHelper.imageButton(playImageTitle, frame: CGRectMake(0,0,buttonSize,buttonSize), target: nil, action: nil)
                playerButton.center = center
                addSubview(playerButton)
                
                // Create a snapshot with the playbutton
                self.image = snapshot
                /*if let snapshotWithPlayButton = captureView(self) {
                    snapshot = snapshotWithPlayButton
                } */
                
                self.fileSnapshot = snapshot
                
                //Remove the Play button 
                //playerButton.removeFromSuperview()
            } catch{}
        }
    }
    

    
    func setLocation(location: CGPoint) {
        self.center = location
    }
    

}


class VideoItemViewController: UIViewController, AVPlayerViewControllerDelegate, NewMomentItemGestureDelegate {
    var manager: NewMomentManager?
    var parentVC: NewMomentCanvasViewController?
    
    var playerVC: AVPlayerViewController?
    var videoView: VideoItemView = VideoItemView()
    
    convenience init() {
        self.init(manager: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(manager: NewMomentManager?) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
        
        initParentVC()
        initView()
    }
    
    private func initView() {
        self.view = videoView
    }
    
    private func initParentVC() {
        if let manager = manager {
            if let canvas = manager.canvasVC {
                self.parentVC = canvas
            }
        }
    }

    func addRecordedVideo(fileURL url: NSURL, location: CGPoint) -> Bool {
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(URL: url)
        
        self.playerVC = playerVC
        videoView.setFileURL(fileURL: url)
        videoView.setLocation(location)
        addTapToPlayGR()
        
        return true
    }

    func addVideo(videoItem: VideoItem) -> Bool {
        if let url = videoItem.getURL() {
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(URL: url)
            
            self.playerVC = playerVC
            videoView.loadVideo(fileURL: url, frame: videoItem.getFrame(), zPosition: videoItem.getZPosition(), snapshot: videoItem.getSnapshot())
            addTapToPlayGR()
            return true
        }
        
        return false
    }
    
    /*********************************************************************************
     
     GESTURE RECOGNIZERS
     
     *********************************************************************************/
    
    var trashGR: UITapGestureRecognizer?
    var dragGR: UIPanGestureRecognizer?
    var pinchGR: UIPinchGestureRecognizer?
    var tapToPlayGR: UITapGestureRecognizer?
    
    func addTapToPlayGR() {
        let tapToPlayGR = UITapGestureRecognizer(target: self, action: "play")
        if let parentVC = self.parentVC {
            tapToPlayGR.enabled = parentVC.enableInteraction
        } else {
            tapToPlayGR.enabled = true
        }
        
        self.view.addGestureRecognizer(tapToPlayGR)
        self.tapToPlayGR = tapToPlayGR
    }
    
    func addTrashGR(trashGR: UITapGestureRecognizer) {
        self.trashGR = trashGR
        self.view.addGestureRecognizer(trashGR)
    }
    
    func addDragGR(dragGR: UIPanGestureRecognizer) {
        self.dragGR = dragGR
        self.view.addGestureRecognizer(dragGR)
    }
    
    func addPinchGR(pinchGR: UIPinchGestureRecognizer) {
        self.pinchGR = pinchGR
        self.view.addGestureRecognizer(pinchGR)
    }
    
    func addRotateGR(rotateGR: UIRotationGestureRecognizer) {
    }
    
    func enableTrash(enabled: Bool) {
        if let trashGR = self.trashGR {
            trashGR.enabled = enabled
        }
        
        tapToPlayGR?.enabled = !enabled
    }
    
    func enableViewMode(enabled: Bool) {
        trashGR?.enabled = !enabled
        dragGR?.enabled = !enabled
        pinchGR?.enabled = !enabled
    }
    
    func tapToTrash(sender: UITapGestureRecognizer) {
        if let senderView = sender.view {
            if sender.numberOfTouches() != 1 {
                return
            }
            senderView.removeFromSuperview()
            self.removeFromParentViewController()
        }
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
