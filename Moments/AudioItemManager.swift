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
    
    var audioItems : [AudioItemViewController] = [AudioItemViewController]()
    
    override init() {
        super.init()
        self.type = ItemType.Audio
        self.debugPrefix = "[AudioItemManager] -"
    }
    
    func addAudio(audioURL: NSURL, location: CGPoint) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOfURL: audioURL)
            if let audioItemVC: AudioItemViewController = super.canvas!.storyboard?.instantiateViewControllerWithIdentifier("audioPlayer") as? AudioItemViewController {
                audioItemVC.player = audioPlayer
                audioItemVC.manager = self
                audioItemVC.view.center = location
                
                super.canvas!.view.addSubview(audioItemVC.view)
                super.canvas!.addChildViewController(audioItemVC)
            }
        } catch {
            debug(debugPrefix + "audio player cannot be created")
        }
    }
    
    func loadAudio(audioItem: AudioItemEntry) -> AudioItemViewController {
        let newAudioVC = AudioItemViewController(manager: self)
        newAudioVC.addAudio(audioItem)
        self.audioItems.append(newAudioVC)
        
        return newAudioVC
    }

    override func saveAllItemEntry() {
        var id = getId()
        
        for audioItem in audioItems {
            let view = audioItem.view
            var audioItemEntry = AudioItemEntry(id: id, frame: view.frame)

            super.superManager!.addAudioItemEntry(audioItemEntry)
            id += 1
        }
    }
    
    override func setEditMode(editMode: Bool) {
        for audioItem in audioItems {
            audioItem.view.userInteractionEnabled = editMode
        }
    }

}
