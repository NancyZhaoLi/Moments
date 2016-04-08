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

class AudioItemView: UIView {
    var playerButton: UIButton!
    var playImageTitle = "play_icon.png"
    var musicPlayImageTitle = "music2_icon.png"
    var pauseImageTitle = "pause_icon.png"
    var buttonSize: CGFloat = 80.0
    
    var fileURL: NSURL?
    var musicURL: NSURL?
    var persistentID: String?
    
    init() {
        super.init(frame: CGRectMake(0, 0, buttonSize + 20.0, buttonSize + 20.0))
        playerButton = ButtonHelper.imageButton(playImageTitle, frame: CGRectMake(0,0,buttonSize,buttonSize), target: nil, action: nil)
        playerButton.center = self.center
        self.addSubview(playerButton)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    func setMusicPlayImage(){
        playerButton.setImage(UIImage(named: musicPlayImageTitle), forState: .Normal)
    }
    func setPlayImage() {
        playerButton.setImage(UIImage(named: playImageTitle), forState: .Normal)
    }
    
    func setPauseImage() {
        playerButton.setImage(UIImage(named: pauseImageTitle), forState: .Normal)
    }
    

}


class AudioItemViewController: ItemViewController, AVAudioPlayerDelegate	 {
    var player: AVAudioPlayer?

    var audioView: AudioItemView = AudioItemView()
    

    override init?(manager: NewMomentManager?) {
        super.init(manager: manager)

        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView() {
        view = self.audioView
        if let manager = self.manager {
           audioView.playerButton.enabled = manager.enableInteraction
        }
    }
    
    func play(){
        if let player = self.player {
            if player.play() {
                setButtonForPause()
            } else {
                print("ERROR: fail to play")
            }
        } else {
            print("ERROR: player is nil")
        }

    }

    func pause() {
        if player!.playing {
            setButtonForPlay()
            player!.pause()
        }
    }
    
    func setButtonForPause() {
        audioView.setPauseImage()
        audioView.playerButton.removeTarget(self, action: "play")
        audioView.playerButton.addTarget(self, action: "pause")
    }
    
    func setButtonForPlay() {
        if audioView.musicURL == nil{
            audioView.setPlayImage()
        }
        else{
            audioView.setMusicPlayImage()
        }
        audioView.playerButton.removeTarget(self, action: "pause")
        audioView.playerButton.addTarget(self, action: "play")
    }
    
    func setMusicButtonForPlay(){
        audioView.setMusicPlayImage()
        audioView.playerButton.removeTarget(self, action: "pause")
        audioView.playerButton.addTarget(self, action: "play")
    
    }

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true {
            player.stop()
            setButtonForPlay()
        }
    }

    override func addItem(musicItem music: MPMediaItem, location: CGPoint) {
        do {
            if let url = music.assetURL {
                player = try AVAudioPlayer(contentsOfURL: url)
                player?.delegate = self
                view.center = location
                audioView.musicURL = url
                audioView.persistentID = String(music.persistentID)
                audioView.playerButton.addTarget(self, action: "play")
                audioView.setMusicPlayImage()
                
                super.addToCanvas()
                super.addGR()
            }
        } catch {
            print("ERROR: fail to initiate audioPlayer in AddMusicAudio of AudioItemViewController")
        }
    }
    
    override func addItem(recordingURL url: NSURL, location: CGPoint){
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            player?.delegate = self
            view.center = location
            audioView.fileURL = url
            audioView.playerButton.addTarget(self, action: "play")
            
            super.addToCanvas()
            super.addGR()
        } catch {
            print("ERROR: fail to initiate audioPlayer in AddRecordingAudio of AudioItemViewController")
        }
    }
    
    override func addItem(audio audio: AudioItem) {
        do {
            if let url = audio.getURL() {
                self.player = try AVAudioPlayer(contentsOfURL: url)
                self.player?.delegate = self
                audioView.frame = audio.getFrame()
                audioView.layer.zPosition = CGFloat(audio.getZPosition())
                audioView.fileURL = url
                audioView.playerButton.addTarget(self, action: "play")
                
                super.addToCanvas(audio.getZPosition())
                super.addGR()
            } else {
                print("no url found for audioItem")
            }
        } catch {
            print("ERROR: fail to initiate audioPlayer in AddAudio of AudioItemViewController")
        }
    }
    
    override func addPinchGR() {}
    
    override func addRotateGR() {}
    
    override func enableTrash(enabled: Bool) {
        super.enableTrash(enabled)
        audioView.playerButton.enabled = !enabled
    }
    
    override func tapToTrash(sender: UITapGestureRecognizer) {
        super.tapToTrash(sender)
    }
}

