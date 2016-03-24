//
//  AudioMapping.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MediaPlayer

class AudioMapping: NSManagedObject {
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(fileURL: NSURL) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("AudioMapping", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setMappingAudioURL(fileURL)
        } else {
            super.init()
            print("ERROR: entity not found for AudioMapping")
            return nil
        }
    }
    
    init?(persistentID: String, musicURL: NSURL) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("AudioMapping", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setMappingPersistentID(persistentID)
            setMappingAudioURL(musicURL)
            //writeAudioToFile()
        } else {
            super.init()
            print("ERROR: entity not found for AudioMapping")
            return nil
        }
    }

    func setMappingPersistentID(persistentID: String) {
        self.persistentID = persistentID
    }
    
    func setMappingAudioURL() {
        let documentsURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileName = NSUUID().UUIDString
        self.audioURL = documentsURL.URLByAppendingPathComponent("audio", isDirectory: true).URLByAppendingPathComponent(fileName).URLByAppendingPathExtension("music").absoluteString
        
    }
    
    func setMappingAudioURL(audioURL: NSURL) {
        self.audioURL = audioURL.absoluteString
    }
    
    private func writeAudioToFile(audio: MPMediaItem) {
        if let url: NSURL = audio.assetURL {
            //let avAsset: AVURLAsset =
        }
    }
    
    func getURL() ->
        NSURL {
            return NSURL(string: self.audioURL)!
    }
    
    func addAudioItem(audioItem: AudioItem) {
        let containedAudioItem = self.mutableSetValueForKey("containedAudioItem")
        
        if self.managedObjectContext != nil {
            containedAudioItem.addObject(audioItem)
        }
    }
    
    static func getAudioMappingGivenPersistentID(persistentID: String) -> AudioMapping? {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "AudioMapping")
        request.predicate = NSPredicate(format: "persistentID = %@", persistentID)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let results = try context.executeFetchRequest(request) as! [AudioMapping]
            if results.isEmpty {
                return nil
            } else {
                return results[0]
            }
        } catch {
            fatalError("Failure to fetch audioMapping: \(error)")
        }
        
        return nil
    }
    
    static func getAudioMappingGivenFileURL(fileURL: NSURL) -> AudioMapping? {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "AudioMapping")
        request.predicate = NSPredicate(format: "audioURL = %@", fileURL.absoluteString)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let results = try context.executeFetchRequest(request) as! [AudioMapping]
            if results.isEmpty {
                return nil
            } else {
                return results[0]
            }
        } catch {
            fatalError("Failure to fetch audioMapping: \(error)")
        }
        
        return nil
    }
}
