//
//  CoreDataSaveHelper.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CoreDataSaveHelper {

    static func saveNewMomentToCoreData(moment:MomentEntry) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Moment", inManagedObjectContext: context)
        
        
        var momentMO = Moment(entity: entity!, insertIntoManagedObjectContext: context)
        momentMO.backgroundColour = moment.backgroundColour
        momentMO.date = moment.date
        print(moment.favourite)
        momentMO.favourite = NSNumber(bool: moment.favourite)
        momentMO.id = NSNumber(longLong: moment.id)
        momentMO.title = moment.title
        momentMO.containedAudioItem = NSSet()
        momentMO.containedImageItem = NSSet()
        momentMO.containedTextItem = NSSet()
        momentMO.containedVideoItem = NSSet()
        momentMO.containedStickerItem = NSSet()
        
        let containedAudioItem = momentMO.mutableSetValueForKey("containedAudioItem")
        let containedImageItem = momentMO.mutableSetValueForKey("containedImageItem")
        let containedTextItem = momentMO.mutableSetValueForKey("containedTextItem")
        let containedVideoItem = momentMO.mutableSetValueForKey("containedVideoItem")
        let containedStickerItem = momentMO.mutableSetValueForKey("containedStickerItem")
        
        for textItem in moment.textItemEntries {
            let textItemMO = saveTextItemToCoreData(textItem)
            containedTextItem.addObject(textItemMO)
        }
        
        for imageItem in moment.imageItemEntries {
            let imageItemMO = saveImageItemToCoreData(imageItem)
            containedImageItem.addObject(imageItemMO)
        }
        
        /*
        for audioItem in moment.audioItemEntries {
            saveAudioItemToCoreData(audioItem)
        }
        
        for videoItem in moment.videoItemEntries {
            saveVideoItemToCoreData(videoItem)
        }
        
        let category: CategoryEntry = moment.category!

        */

        do{
            try context.save()
        } catch {
            print("ERROR: saving context to Moment")
        }
        
    }
    		
    static func saveTextItemToCoreData(textItem: TextItemEntry) -> TextItem {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("TextItem", inManagedObjectContext: context)
        
        var textItemMO = TextItem(entity: entity!, insertIntoManagedObjectContext: context)
        textItemMO.id = NSNumber(longLong: textItem.id)
        textItemMO.content = textItem.getContent()
        textItemMO.frame = NSStringFromCGRect(textItem.getFrame())
        textItemMO.rotation = NSNumber(float: textItem.getRotation())
        textItemMO.otherAttribute = NSKeyedArchiver.archivedDataWithRootObject(textItem.getOtherAttribute())
        
        do {
            try context.save()
        } catch {
            print("ERROR: cannot save textItem to context")
        }
        
        return textItemMO
    }
    
    static func saveImageItemToCoreData(imageItem: ImageItemEntry) -> ImageItem {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("ImageItem", inManagedObjectContext: context)
        
        var imageItemMO = ImageItem(entity: entity!, insertIntoManagedObjectContext: context)
        imageItemMO.id = NSNumber(longLong: imageItem.id)
        //imageItemMO.url = imageItem.url
        imageItemMO.image = UIImagePNGRepresentation(imageItem.image)
        imageItemMO.frame = NSStringFromCGRect(imageItem.frame)
        imageItemMO.rotation = NSNumber(float: imageItem.rotation)
        
        do {
            try context.save()
        } catch {
            print("ERROR: cannot save imageItem to context")
        }
        
        return imageItemMO

    }
    
    static func saveCategoryToCoreData(category: CategoryEntry) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)
        
        
        var categoryMO = Category(entity: entity!, insertIntoManagedObjectContext: context)
        categoryMO.colour = category.colour
        categoryMO.name = category.name
        
        do{
            try context.save()
        } catch {
            print("ERROR: saving context to Category")
        }
        
    }
}

