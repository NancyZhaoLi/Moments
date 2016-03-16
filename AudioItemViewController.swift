//
//  AudioPlayerViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-21.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class AudioItemViewController: UIViewController {

    var player: AVAudioPlayer?
    var havePlayed: Bool = false
    var timer: NSTimer!
    var manager: AudioItemManager?
    var parentView: UIView?
    
    let pinchRec: UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    let panRec: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var progBar: UIProgressView!
    @IBOutlet weak var stopButton: UIButton!
    
    /*init(manager: AudioItemManager, location: CGPoint) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
        initView(location)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        setupParentView()
        setupGestureRecognizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initView(location: CGPoint) {
        self.view = UIView(frame: CGRectMake(location.x, location.y, 30,30))
        let playButton = UIButton(frame: CGRectMake(0,0,30,30))
        playButton.setBackgroundImage(UIImage(named: ""), forState: .Normal)
        //playButton.addTarget(self, action: "play:", forControlEvents: <#T##UIControlEvents#>)
        
        
        self.view.addSubview(playButton)
    }
    
    func setupGestureRecognizer() {
        pinchRec.addTarget(self, action: "pinchedView:")
        panRec.addTarget(self, action: "draggedView:")
        
        self.view.addGestureRecognizer(pinchRec)
        self.view.addGestureRecognizer(panRec)
        
        self.view.userInteractionEnabled = true
        self.view.multipleTouchEnabled = true
    }
    
    @IBAction func playOrPause(sender: AnyObject) {
        if let player = self.player {
            if havePlayed == false {
                havePlayed = true
                stopButton.enabled = true
                timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
            }
            if player.playing {
                playOrPauseButton.setTitle("Play", forState: UIControlState.Normal)
                player.pause()
            } else {
                print("playing?")
                playOrPauseButton.setTitle("Pause", forState: UIControlState.Normal)
                player.play()
                print("playing!")
            }
        }
        
    }
    
    @IBAction func stop(sender: AnyObject) {
        if let player = self.player {
            stopButton.enabled = false
            player.stop()
            player.currentTime = 0
            havePlayed = false
        }
    }
    
    func updateTime() {
        if let player = self.player {
            let currentTime = Float(player.currentTime)
            let duration = Float(player.duration)
            progBar.progress = currentTime / duration
        }
    }

    func pinchedView(sender: UIPinchGestureRecognizer) {
        print("pinched")
        self.view.bringSubviewToFront(self.view)
        sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1.0
    }
    
    func setupParentView() -> Bool {
        if let canvas = self.manager?.canvas {
            if let view = canvas.view {
                self.parentView = view
                return true
            }
        }
        
        return false
    }
    
    func draggedView(sender: UIPanGestureRecognizer) {
        print("dragged")
        
        if self.parentView == nil {
            setupParentView()
        }
        if let parentView = self.parentView {
            if let senderView = sender.view {
                parentView.bringSubviewToFront(senderView)
                let translation = sender.translationInView(parentView)
                senderView.center = CGPointMake(senderView.center.x + translation.x, senderView.center.y + translation.y)
                sender.setTranslation(CGPointZero, inView: parentView)
                parentView.sendSubviewToBack(senderView)
            }
        }
    }
    
}

