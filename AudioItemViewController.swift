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
    var manager: NewMomentManager!
    var parentView: UIView!
    
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var progBar: UIProgressView!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(manager: NewMomentManager())
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(manager: NewMomentManager) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
        if !initParentView() {
            fatalError("ERROR: [TextItemViewController] parentView init failed")
        }
        
        initGestureRecognizer()
    }
    
    func initParentView() -> Bool {
        if let canvas = self.manager.canvas, view = canvas.view {
            self.parentView = view
            return true
        }
        return false
    }
    
    func initView(location: CGPoint) {
        self.view = UIView(frame: CGRectMake(location.x, location.y, 30,30))
        let playButton = UIButton(frame: CGRectMake(0,0,30,30))
        playButton.setBackgroundImage(UIImage(named: ""), forState: .Normal)
        //playButton.addTarget(self, action: "play:", forControlEvents: <#T##UIControlEvents#>)
        
        
        self.view.addSubview(playButton)
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
    
    
    func addAudio(audioItem: AudioItemEntry) {
        
    }
    /*********************************************************************************
     
     GESTURE RECOGNIZERS
     
     *********************************************************************************/
    
    let pinchRec: UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    let panRec: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    func initGestureRecognizer() {
        self.pinchRec.addTarget(self, action: "pinchedView:")
        self.panRec.addTarget(self, action: "draggedView:")
        
        self.view.addGestureRecognizer(self.pinchRec)
        self.view.addGestureRecognizer(self.panRec)

        self.view.multipleTouchEnabled = true
    }
    
    func pinchedView(sender: UIPinchGestureRecognizer) {
        self.view.bringSubviewToFront(self.view)
        sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1.0
    }
    
    func draggedView(sender: UIPanGestureRecognizer) {
        if let senderView = sender.view {
            self.parentView.bringSubviewToFront(senderView)
            let translation = sender.translationInView(parentView)
            senderView.center = CGPointMake(senderView.center.x + translation.x, senderView.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: parentView)
            self.parentView.sendSubviewToBack(senderView)
        }
    }
    
}

