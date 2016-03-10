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
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var progBar: UIProgressView!
    @IBOutlet weak var stopButton: UIButton!

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
                playOrPauseButton.setTitle("Pause", forState: UIControlState.Normal)
                player.play()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

