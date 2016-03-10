//
//  AudioItemManager.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-09.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

class AudioItemManager : ItemManager {
    
    override init() {
        super.init()
        self.type = ItemType.Audio
        self.debugPrefix = "[AudioItemManager] -"
    }
    
    func addAudio(audio: MPMediaItem) {
        let debugPrefix = "[addAudio] - "
        
        if let url = audio.assetURL {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                if let audioItemVC = super.canvas!.storyboard?.instantiateViewControllerWithIdentifier("audioPlayer") as? AudioItemViewController {
                    audioItemVC.player = audioPlayer
                    
                    super.canvas!.view.addSubview(audioItemVC.view)
                    super.canvas!.addChildViewController(audioItemVC)
                }
            } catch {
                debug(debugPrefix + "audio player cannot be created")
            }
        }
    }
    
    func loadAudio(audioItem: AudioItemEntry) -> AudioItemViewController {
        return AudioItemViewController()
    }
    
}
