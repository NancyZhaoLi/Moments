//
//  Moment.swift
//  Moments
//
//  Created by Xin Lin and Yuning Xue on 2016-03-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Firebase

let ref = Firebase(url:"http://momentsxmen.firebaseio.com/")

class Moment: NSManagedObject {
    
    var textItems = [TextItem]()
    var imageItems = [ImageItem]()
    var audioItems = [AudioItem]()
    var videoItems = [VideoItem]()
    var stickerItems = [StickerItem]()
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(backgroundColour: UIColor, favourite: Bool, title: String, category: Category) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Moment", inManagedObjectContext: context)
        let trash: Bool = false
        let userId: String = ref.authData.uid
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setMomentBackgroundColour(backgroundColour)
            setMomentDate(nil)
            setMomentFavourite(favourite)
            setMomentId(nil)
            setMomentTitle(title)
            setMomentCategory(category)
            setMomentTrashed(trash)
            setMomentUserId(userId)
        } else {
            super.init()
            print("ERROR: entity not found for Moment")
            return nil
        }
    }
    
    init?(backgroundColour: UIColor, date: NSDate, favourite: Bool, id: Int64, title: String, category: Category) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Moment", inManagedObjectContext: context)
        let trash : Bool = false
        let userId: String = ref.authData.uid
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setMomentBackgroundColour(backgroundColour)
            setMomentDate(date)
            setMomentFavourite(favourite)
            setMomentId(id)
            setMomentTitle(title)
            setMomentCategory(category)
            setMomentTrashed(trash)
            setMomentUserId(userId)
        } else {
            super.init()
            print("ERROR: entity not found for Moment")
            return nil
        }

    }
   //-------Monica add this for initialize a moment with trash property-----------
    init?(backgroundColour: UIColor, favourite: Bool, title: String, trash : Bool, category: Category) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Moment", inManagedObjectContext: context)
        let userId : String = ref.authData.uid
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setMomentBackgroundColour(backgroundColour)
            setMomentDate(nil)
            setMomentFavourite(favourite)
            setMomentId(nil)
            setMomentTitle(title)
            setMomentCategory(category)
            setMomentTrashed(trash)
            setMomentUserId(userId)
        } else {
            super.init()
            print("ERROR: entity not found for Moment")
            return nil
        }
    }
    
    init?(backgroundColour: UIColor, favourite: Bool, title: String, trash : Bool, category: Category, userId: String) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Moment", inManagedObjectContext: context)
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setMomentBackgroundColour(backgroundColour)
            setMomentDate(nil)
            setMomentFavourite(favourite)
            setMomentId(nil)
            setMomentTitle(title)
            setMomentCategory(category)
            setMomentTrashed(trash)
            setMomentUserId(userId)
        } else {
            super.init()
            print("ERROR: entity not found for Moment")
            return nil
        }
    }
   //-------------------------end of Monica's new init--------------------------------
    
    func getBackgroundColour() -> UIColor {
        return self.backgroundColour as! UIColor
    }
    
    func setMomentBackgroundColour(backgroundColour: UIColor) {
        self.backgroundColour = backgroundColour
    }
    
    private func setMomentDate(date: NSDate? ) {
        if let date = date {
            self.date = date
        } else {
            self.date = NSDate()
        }
    }
    
    func getDate() -> NSDate {
        return self.date
    }
    
    func getFavourite() -> Bool {
        return self.favourite.boolValue
    }
    
    func setMomentFavourite(favourite: Bool) {
        self.favourite = NSNumber(bool: favourite)
    }
//--------------Monica add these for trash page---------------------
    func getTrashed() -> Bool {
        return self.trashed.boolValue
    }
    func setMomentTrashed(Trashed: Bool){
        self.trashed = NSNumber(bool: Trashed)
        
        //Special part for save the trahsed status
        if let context = self.managedObjectContext {
            do {
               try context.save()
                // This could add a pop up window
            }
            catch {
                print("Failed on moving into trash")
            }
        }//Specil part for save the trash status
    }
    
    func setMomentUnTrashed(){
        print("setting this moment is not in trash")
        self.trashed = NSNumber(bool: false)
        //Special part for save the trahsed status
        if let context = self.managedObjectContext {
            do {
                try context.save()
                // This could add a pop up window
            }
            catch {
                print("Failed on takeing out of trash")
            }
        }//Specil part for save the trash status
        
    }
//---------------end of addition for trash page-----------------------------------
    private func setMomentUserId(id : String){
       self.userID = id
    }
    private func setMomentId(id: Int64?) {
        if let id = id {
            self.id = NSNumber(longLong: id)
        } else {
            self.id = computeId()
        }
    }
    
    private func computeId() -> NSNumber {
        let idPrefix = self.date.shortYear + self.date.month + self.date.day
        var idSuffix = "0000"
        
        if let maxIdInCD : Int64 = CoreDataFetchHelper.requestMaxOfIdGreaterThan(Int64(idPrefix + "0000")!, entity: "Moment") {
            idSuffix = String(format: "%04lld", maxIdInCD + 1)
        }
        
        return NSNumber(longLong: Int64(idPrefix + idSuffix)!)
    }
    func getUserId() -> String {
        return self.userID
    }
    
    func getId() -> Int64 {
        return self.id.longLongValue
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func setMomentTitle(title: String) {
        self.title = title
    }
    
    func getCategory() -> Category {
        return self.inCategory
    }
    
    func setMomentCategory(category: Category) {
        self.inCategory = category
    }
    
    func addText(text: TextItem) {
        /*if let context = self.managedObjectContext {
            context.insertObject(text)
            let containedTextItem = self.mutableSetValueForKey("containedTextItem")
            containedTextItem.addObject(text)
        }*/
        textItems.append(text)
    }
    
    func firstText() -> TextItem? {
        if numOfText() > 0 {
            if let savedTextItems = self.containedTextItem {
                return savedTextItems.anyObject() as! TextItem?
            } else {
                return textItems[0]
            }
        }
        
        return nil
    }
    
    func numOfText() -> Int {
        if let savedTextItems = self.containedTextItem {
            return textItems.count + savedTextItems.count
        }
        
        return textItems.count
    }
    
    func getAllSavedText() -> [TextItem] {
        if let savedTextItems = self.containedTextItem {
            return savedTextItems.allObjects as! [TextItem]
        }
        
        return [TextItem]()
    }
    
    func addImage(image: ImageItem) {
        imageItems.append(image)
    }
    
    func firstImage() -> ImageItem? {
        if numOfImage() > 0 {
            if let savedImageItems = self.containedImageItem {
                return savedImageItems.anyObject() as! ImageItem?
            } else {
                return imageItems[0]
            }
        }
        
        return nil
    }
    
    func numOfImage() -> Int {
        if let savedImageItems = self.containedImageItem {
            return imageItems.count + savedImageItems.count
        }
        
        return imageItems.count
    }
    
    func getAllSavedImage() -> [ImageItem] {
        if let savedImageItems = self.containedImageItem {
            return savedImageItems.allObjects as! [ImageItem]
        }
        
        return [ImageItem]()
    }
    
    func addAudio(audio: AudioItem) {
        audioItems.append(audio)
    }
    
    func getAllSavedAudio() -> [AudioItem] {
        if let savedAudioItems = self.containedAudioItem {
            return savedAudioItems.allObjects as! [AudioItem]
        }
        
        return [AudioItem]()
    }
    
    func addVideo(video: VideoItem) {
        videoItems.append(video)
    }
    
    func getAllSavedVideo() -> [VideoItem] {
        if let savedVideoItems = self.containedVideoItem {
            return savedVideoItems.allObjects as! [VideoItem]
        }
        return [VideoItem]()
    }
    
    func addSticker(sticker: StickerItem) {
        stickerItems.append(sticker)
    }
    
    func getAllSavedSticker() -> [StickerItem] {
        if let savedStickerItems = self.containedStickerItem {
            return savedStickerItems.allObjects as! [StickerItem]
        }
        return [StickerItem]()
    }
    
    
    func save() -> Bool {
        print("save moment begin")
        let containedTextItem = self.mutableSetValueForKey("containedTextItem")
        let containedImageItem = self.mutableSetValueForKey("containedImageItem")
        let containedAudioItem = self.mutableSetValueForKey("containedAudioItem")
        let containedVideoItem = self.mutableSetValueForKey("containedVideoItem")
        let containedStickerItem = self.mutableSetValueForKey("containedStickerItem")
        
        print("item list loaded")
        
        if let context = self.managedObjectContext {
            for textItem in textItems {
                context.insertObject(textItem)
                containedTextItem.addObject(textItem)
            }
            
            print("text done")
            
            for imageItem in imageItems {
                context.insertObject(imageItem)
                containedImageItem.addObject(imageItem)
            }
            
            print("image done")
            
            for audioItem in audioItems {
                context.insertObject(audioItem)
                if audioItem.save() {
                    containedAudioItem.addObject(audioItem)
                    do{
                        try context.save()
                        print("SUCCESS: saving audioItem to core data")
                    } catch {
                        print("ERROR: failed to save audioItem to core data \(error)")
                    }
                    print("save audioItem Successfully")
                } else {
                    print("save audioItem failed ")
                }
            }
            
            for videoItem in videoItems {
                videoItem.save()
                context.insertObject(videoItem)
                containedVideoItem.addObject(videoItem)
            }
            
            for stickerItem in stickerItems {
                context.insertObject(stickerItem)
                containedStickerItem.addObject(stickerItem)
            }
            
            do{
                print("try to save context")
                try context.save()
                clearItems()
                print("SUCCESS: saving moment to core data")
                return true
            } catch {
                print("ERROR: saving moment to core data \(error)")
            }
        }
        
        clearItems()
        return false
    }
    
    func delete() -> Bool {
        if let context = self.managedObjectContext {
            context.deleteObject(self)
            do {
                try context.save()
                return true
            } catch {
                print("ERROR: fail to delete moment")
            }
        }
        return false
    }
    
    func deleteContent() -> Bool {
        let containedTextItem = self.mutableSetValueForKey("containedTextItem")
        let containedImageItem = self.mutableSetValueForKey("containedImageItem")
        let containedAudioItem = self.mutableSetValueForKey("containedAudioItem")
        let containedVideoItem = self.mutableSetValueForKey("containedVideoItem")
        let containedStickerItem = self.mutableSetValueForKey("containedStickerItem")
    
        if let context = self.managedObjectContext {
            for textItem in containedTextItem {
                context.deleteObject(textItem as! TextItem)
            }
            
            for imageItem in containedImageItem {
                context.deleteObject(imageItem as! ImageItem)
            }
            
            for audioItem in containedAudioItem {
                context.deleteObject(audioItem as! AudioItem)
            }
            
            for videoItem in containedVideoItem {
                context.deleteObject(videoItem as! VideoItem)
            }
            
            for stickerItem in containedStickerItem {
                context.deleteObject(stickerItem as! StickerItem)
            }
            
            do{
                try context.save()
                print("SUCCESS: delete moment content fromt core data")
                clearItems()
                return true
            } catch {
                print("ERROR: delete moment content from core data \(error)")
            }
        }
        
        clearItems()
        return false

    }
    
    func clearItems() {
        textItems.removeAll()
        imageItems.removeAll()
        audioItems.removeAll()
        videoItems.removeAll()
        stickerItems.removeAll()
    }
}
