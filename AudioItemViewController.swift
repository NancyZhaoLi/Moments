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
    var musicPlayImageTitle = "music_icon.png"
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


class AudioItemViewController: UIViewController, AVAudioPlayerDelegate, NewMomentItemGestureDelegate {
    var player: AVAudioPlayer?
    var manager: NewMomentManager?
    var parentVC: NewMomentCanvasViewController?

    var audioView: AudioItemView = AudioItemView()
    
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
    
    private func initParentVC() {
        if let manager = manager {
            if let canvas = manager.canvasVC {
                self.parentVC = canvas
            }
        }
    }
    
    func initView() {
        view = self.audioView
        if let parentVC = self.parentVC {
            audioView.playerButton.enabled = parentVC.enableInteraction
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
        audioView.setPlayImage()
        audioView.playerButton.removeTarget(self, action: "pause")
        audioView.playerButton.addTarget(self, action: "play")
    }
    
    func setMusicButtonForPlay(){
        audioView.setMusicPlayImage()
        audioView.playerButton.removeTarget(self, action: "pause")
        audioView.playerButton.addTarget(self, action: "play")
    
    }
    
    func addMusicAudio(music: MPMediaItem, location: CGPoint) -> Bool {
        do {
            if let url = music.assetURL {
                player = try AVAudioPlayer(contentsOfURL: url)
                player?.delegate = self
                view.center = location
                audioView.musicURL = url
                audioView.persistentID = String(music.persistentID)
                audioView.playerButton.addTarget(self, action: "play")
                return true
            }
        } catch {
            print("ERROR: fail to initiate audioPlayer in AddMusicAudio of AudioItemViewController")
        }
        
        return false
    }

    func addRecordedAudio(fileURL url: NSURL, location: CGPoint) -> Bool {
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            player?.delegate = self
            view.center = location
            audioView.fileURL = url
            audioView.playerButton.addTarget(self, action: "play")
            return true
        } catch {
            print("ERROR: fail to initiate audioPlayer in AddRecordingAudio of AudioItemViewController")
        }
        
        return false
    }
    
    func addAudio(audioItem: AudioItem) -> Bool {
        do {
            if let url = audioItem.getURL() {
                self.player = try AVAudioPlayer(contentsOfURL: url)
                self.player?.delegate = self
                audioView.frame = audioItem.getFrame()
                audioView.layer.zPosition = CGFloat(audioItem.getZPosition())
                audioView.fileURL = url
                audioView.playerButton.addTarget(self, action: "play")
                return true
            } else {
                print("no url found for audioItem")
            }
        } catch {
            print("ERROR: fail to initiate audioPlayer in AddAudio of AudioItemViewController")
        }
        
        return false
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag == true {
            player.stop()
            setButtonForPlay()
        }
    }
    
    /*********************************************************************************
     
     GESTURE RECOGNIZERS
     
     *********************************************************************************/
    var trashGR: UITapGestureRecognizer?
    var dragGR: UIPanGestureRecognizer?
    
    func addTrashGR(trashGR: UITapGestureRecognizer) {
        self.trashGR = trashGR
        self.view.addGestureRecognizer(trashGR)
    }
    
    func addDragGR(dragGR: UIPanGestureRecognizer) {
        self.dragGR = dragGR
        self.view.addGestureRecognizer(dragGR)
    }
    
    func addPinchGR(pinchGR: UIPinchGestureRecognizer) {
    }
    
    func addRotateGR(rotateGR: UIRotationGestureRecognizer) {
    }
    
    func enableTrash(enabled: Bool) {
        if let trashGR = self.trashGR {
            trashGR.enabled = enabled
        }
        audioView.playerButton.enabled = !enabled
    }
    
    func enableViewMode(enabled: Bool) {
        dragGR?.enabled = !enabled
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

