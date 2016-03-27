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
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setMomentBackgroundColour(backgroundColour)
            setMomentDate()
            setMomentFavourite(favourite)
            setMomentId()
            setMomentTitle(title)
            setMomentCategory(category)
        } else {
            super.init()
            print("ERROR: entity not found for Moment")
            return nil
        }
    }

    func getBackgroundColour() -> UIColor {
        return self.backgroundColour as! UIColor
    }
    
    func setMomentBackgroundColour(backgroundColour: UIColor) {
        self.backgroundColour = backgroundColour
    }
    
    private func setMomentDate() {
        self.date = NSDate()
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
    
    private func setMomentId() {
        self.id = computeId()
    }
    
    private func computeId() -> NSNumber {
        let idPrefix = self.date.shortYear + self.date.month + self.date.day
        var idSuffix = "0000"
        
        if let maxIdInCD : Int64 = CoreDataFetchHelper.requestMaxOfIdGreaterThan(Int64(idPrefix + "0000")!, entity: "Moment") {
            idSuffix = String(format: "%04lld", maxIdInCD + 1)
        }
        
        return NSNumber(longLong: Int64(idPrefix + idSuffix)!)
    }
    
    func getMomentId() -> Int64 {
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
        let containedTextItem = self.mutableSetValueForKey("containedTextItem")
        let containedImageItem = self.mutableSetValueForKey("containedImageItem")
        let containedAudioItem = self.mutableSetValueForKey("containedAudioItem")
        //let containedVideoItem = self.mutableSetValueForKey("containedVideoItem")
        let containedStickerItem = self.mutableSetValueForKey("containedStickerItem")
        
        if let context = self.managedObjectContext {
            for textItem in textItems {
                context.insertObject(textItem)
                containedTextItem.addObject(textItem)
            }
            
            for imageItem in imageItems {
                context.insertObject(imageItem)
                containedImageItem.addObject(imageItem)
            }
            
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
            
            for stickerItem in stickerItems {
                context.insertObject(stickerItem)
                containedStickerItem.addObject(stickerItem)
            }
            
            do{
                try context.save()
                print("SUCCESS: saving moment to core data")
                return true
            } catch {
                print("ERROR: saving moment to core data \(error)")
            }
        }
        
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
}
