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

class AudioItemViewController: UIViewController, AVAudioPlayerDelegate {

    var player: AVAudioPlayer?
    var manager: NewMomentManager?
    var parentVC: UIViewController!
    
    var tapToTrashGR: UITapGestureRecognizer?
    
    var playerButton: UIButton!
    var playImageTitle = "play_icon.png"
    var pauseImageTitle = "pause_icon.png"
    var buttonSize: CGFloat = 80.0
    
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
            fatalError("ERROR: [TextItemViewController] parentView init failed")
        }
        
        initView()
    }
    
    private func initParentView() -> Bool {
        if let canvas = manager!.canvasVC {
            parentVC = canvas
            return true
        }
        return false
    }
    
    func initView() {
        view = UIView()
        view.frame.size = CGSizeMake(buttonSize, buttonSize)
        playerButton = ButtonHelper.imageButton(playImageTitle, frame: CGRectMake(0,0,buttonSize,buttonSize), target: self, action: "play")
        view.addSubview(playerButton)
    }
    
    func play(){
        if player!.play() {
            setButtonForPause()
            print(player!.volume)
        } else {
            print("fail to play")
        }
    }
    
    func setButtonForPause() {
        playerButton.setImage(UIImage(named: pauseImageTitle), forState: .Normal)
        playerButton.removeTarget(self, action: "play")
        playerButton.addTarget(self, action: "pause")
    }
    
    func pause() {
        print("pause")
        if player!.playing {
            setButtonForPlay()
            player!.pause()
        }
    }
    
    func setButtonForPlay() {
        playerButton.setImage(UIImage(named: playImageTitle), forState: .Normal)
        playerButton.removeTarget(self, action: "pause")
        playerButton.addTarget(self, action: "play")
    }

    func addPlayer(player: AVAudioPlayer, location: CGPoint) {
        self.player = player
        self.player?.delegate = self
        self.view.center = location
    }
    
    func addAudio(audio: AudioItemEntry) {
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true {
            player.stop()
            setButtonForPlay()
        }
    }
    
}

