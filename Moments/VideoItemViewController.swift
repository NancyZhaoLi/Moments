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

class VideoItemView: UIView {
    private var playerButton: UIButton!
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
        initPlayerButton()
        setPlayImage()
    }
    
    private func initPlayerButton() {
        playerButton = ButtonHelper.imageButton(playImageTitle, frame: CGRectMake(0,0,buttonSize,buttonSize), target: nil, action: nil)
        //playerButton.center = self.center
        print("self.center: \(self.center), self,frame: \(self.frame)")
        self.addSubview(playerButton)
    }
    
    func loadVideo(fileURL url: NSURL, frame: CGRect, zPosition: Int, snapshot: UIImage?) {
        self.fileURL = url
        self.fileSnapshot = snapshot
        self.frame = frame
        self.layer.zPosition = CGFloat(zPosition)
        if let snapshot = snapshot {
            self.backgroundColor = UIColor(patternImage: UIHelper.resizeImage(snapshot, newWidth: frame.size.width, newHeight: frame.size.height))
        }
        initPlayerButton()
    }
    
    func setPlayImage() {
        playerButton.setImage(UIImage(named: playImageTitle), forState: .Normal)
    }
    
    private func setSnapShot() {
        if let fileURL = self.fileURL {
            let asset = AVAsset(URL: fileURL)
            let assetImageGen = AVAssetImageGenerator(asset: asset)
            var time = asset.duration
            time.value = min(time.value, 1)
            
            do {
                var snapshot = try UIImage(CGImage: assetImageGen.copyCGImageAtTime(time, actualTime: nil))
                
                let defaultMaxDimension: CGFloat = 250.0
                let imageMaxDimension:CGFloat = max(snapshot.size.height, snapshot.size.width)
                var resizeRatio: CGFloat = 1.0
                
                if imageMaxDimension > defaultMaxDimension {
                    resizeRatio = imageMaxDimension/defaultMaxDimension
                }
                
                let newWidth = snapshot.size.width/resizeRatio
                let newHeight = snapshot.size.height/resizeRatio
                snapshot = UIHelper.resizeImage(snapshot, newWidth: newWidth, newHeight: newHeight)
                
                let frame = CGRectMake(0,0, newWidth, newHeight)
                self.frame = frame
                self.backgroundColor = UIColor(patternImage: snapshot)
                self.fileSnapshot = snapshot
            } catch{}
        }
    }
    
    func setLocation(location: CGPoint) {
        self.center = location
    }
}


class VideoItemViewController: UIViewController, AVPlayerViewControllerDelegate, NewMomentItemGestureDelegate {

    var manager: NewMomentManager?
    var parentView: UIView!
    
    var playerVC: AVPlayerViewController?

    var tapToTrashGR: UITapGestureRecognizer?
    var videoView: VideoItemView = VideoItemView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(manager: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(manager: NewMomentManager?) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
        if !initParentView() {
            fatalError("ERROR: [AudioItemViewController] parentView init failed")
        }
        
        initView()
    }
    
    private func initView() {
        self.view = videoView
    }
    
    private func initParentView() -> Bool {
        if let canvas = manager!.canvasVC, view = canvas.view {
            self.parentView = view
            return true
        }
        return false
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
    
    func setButtonForPlay() {
        videoView.setPlayImage()
        videoView.playerButton.addTarget(self, action: "play")
    }
    
    func addRecordedVideo(fileURL url: NSURL, location: CGPoint) -> Bool {
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(URL: url)
        
        self.playerVC = playerVC
        self.videoView.setFileURL(fileURL: url)
        self.videoView.setLocation(location)
        setButtonForPlay()
        return true
    }

    
    func addVideo(videoItem: VideoItem) -> Bool {
        if let url = videoItem.getURL() {
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(URL: url)
            
            self.playerVC = playerVC
            self.videoView.loadVideo(fileURL: url, frame: videoItem.getFrame(), zPosition: videoItem.getZPosition(), snapshot: videoItem.getSnapshot())
            setButtonForPlay()
            
            return true
        }
        
        return false
    }
    
    var trashGR: UITapGestureRecognizer?
    var dragGR: UIPanGestureRecognizer?
    var pinchGR: UIPinchGestureRecognizer?
    
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
}
