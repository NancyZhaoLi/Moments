//
//  AudioItem.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MediaPlayer

class AudioItem: NSManagedObject {
    
    internal var persistentID: String?
    internal var fileURL: NSURL?
    internal var musicURL: NSURL?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(frame: CGRect, fileURL url: NSURL, zPosition: Int) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("AudioItem", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: nil)
            setItemFrame(frame)
            setItemZPosition(zPosition)
            self.fileURL = url
        } else {
            super.init()
            print("ERROR: entity not found for AudioItem")
            return nil
        }
    }
    
    init?(frame : CGRect, musicURL url: NSURL, persistentID: String, zPosition: Int) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("AudioItem", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: nil)
            setItemFrame(frame)
            setItemZPosition(zPosition)
            self.musicURL = url
            self.persistentID = persistentID
        } else {
            super.init()
            print("ERROR: entity not found for AudioItem")
            return nil
        }
    }
    
    func getFrame() -> CGRect {
        return CGRectFromString(self.frame)
    }
    
    func setItemFrame(frame: CGRect) {
        self.frame = NSStringFromCGRect(frame)
    }
    
    func getZPosition() -> Int {
        return self.zPosition.integerValue
    }
    
    func setItemZPosition(zPosition: Int) {
        self.zPosition = NSNumber(integer: zPosition)
    }
    
    func addToAudioMapping(fileURL url: NSURL) -> Bool {
        if let audioMapping = AudioMapping.getAudioMappingGivenFileURL(url) {
            //self.audioMapping = audioMapping
            audioMapping.addAudioItem(self)
            return true
        } else if let audioMapping = AudioMapping(fileURL: url) {
            //self.audioMapping = audioMapping
            audioMapping.addAudioItem(self)
            return true
        }
        return false
    }
    
    func addToAudioMapping(musicURL url: NSURL, persistentID: String) -> Bool {
        if let audioMapping = AudioMapping.getAudioMappingGivenPersistentID(persistentID) {
            print("found audioMapping for music")
            //self.audioMapping = audioMapping
            audioMapping.addAudioItem(self)
            return true
        } else if let audioMapping = AudioMapping(persistentID: persistentID, musicURL: url) {
            print("new audioMapping for music")
            //self.audioMapping = audioMapping
            audioMapping.addAudioItem(self)
            return true
        }
        
        return false
    }
    
    func getURL() -> NSURL? {
        if let audioMapping = self.audioMapping {
            return audioMapping.getURL()
        }
        return nil
    }
    
    func save() -> Bool {
        if let persistentID = self.persistentID, musicURL = self.musicURL {
            return addToAudioMapping(musicURL: musicURL, persistentID: persistentID)
        } else if let fileURL = self.fileURL {
            return addToAudioMapping(fileURL: fileURL)
        }
        
        return false
    }
}
