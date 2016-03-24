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

class AudioItem: NSManagedObject {
    
    internal var persistentID: Int64?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(frame : CGRect, zPosition: Int, persistentID: Int64) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("AudioItem", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: nil)
            setItemFrame(frame)
            setItemZPosition(zPosition)
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
    
    func addToAudioMapping(persistentID: Int64) -> Bool {
        if let audioMapping = AudioMapping.getAudioMappingGivenPersistentID(persistentID) {
            audioMapping.addAudioItem(self)
            return true
        } else {
            
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
        if let persistentID = self.persistentID {
            addToAudioMapping(persistentID)
            return true
        }
        
        return false
    }
}
