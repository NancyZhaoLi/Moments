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

    /*static func saveNewMomentToCoreData(moment:Moment) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Moment", inManagedObjectContext: context)
        //context.insertObject(moment)
      /*
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
        momentMO.inCategory = CoreDataFetchHelper.fetchCategoryGivenName(moment.category!)
        */
        let containedAudioItem = moment.mutableSetValueForKey("containedAudioItem")
        let containedImageItem = moment.mutableSetValueForKey("containedImageItem")
        let containedTextItem = moment.mutableSetValueForKey("containedTextItem")
        let containedVideoItem = moment.mutableSetValueForKey("containedVideoItem")
        let containedStickerItem = moment.mutableSetValueForKey("containedStickerItem")
        
        for textItem in moment.textItems {
            //let textItemMO = saveTextItemToCoreData(textItem)
            context.insertObject(textItem)
            containedTextItem.addObject(textItem)
        }
        
        for imageItem in moment.imageItems {
            //let imageItemMO = saveImageItemToCoreData(imageItem)
            context.insertObject(imageItem)
            containedImageItem.addObject(imageItem)
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
        
        for stickerItem in moment.stickerItems {
            context.insertObject(stickerItem)
            containedStickerItem.addObject(stickerItem)
        }

        do{
            try context.save()
        } catch {
            print("ERROR: saveing moment to core data")
        }
        
    }*/
    		
    /*static func saveTextItemToCoreData(textItem: TextItemEntry) -> TextItem {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("TextItem", inManagedObjectContext: context)
        
        let textItemMO = TextItem(entity: entity!, insertIntoManagedObjectContext: context)
        textItemMO.content = textItem.content
        textItemMO.frame = NSStringFromCGRect(textItem.frame)
        textItemMO.rotation = NSNumber(float: textItem.rotation)
        textItemMO.otherAttribute = NSKeyedArchiver.archivedDataWithRootObject(textItem.otherAttribute)
        textItemMO.zPosition = textItem.zPosition
        
        do {
            try context.save()
        } catch {
            print("ERROR: cannot save textItem to context")
        }
        
        return textItemMO
    }*/
    
  /*  static func saveImageItemToCoreData(imageItem: ImageItemEntry) -> ImageItem {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("ImageItem", inManagedObjectContext: context)
        
        let imageItemMO = ImageItem(entity: entity!, insertIntoManagedObjectContext: context)

        imageItemMO.image = UIImagePNGRepresentation(imageItem.image)
        imageItemMO.frame = NSStringFromCGRect(imageItem.frame)
        imageItemMO.rotation = NSNumber(float: imageItem.rotation)
        imageItemMO.zPosition = imageItem.zPosition
        
        do {
            try context.save()
        } catch {
            print("ERROR: cannot save imageItem to context")
        }
        
        return imageItemMO

    }*/
    /*
    static func saveStickerItemToCoreData(stickerItem: StickerItemEntry) -> StickerItem {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("StickerItem", inManagedObjectContext: context)
        
        let stickerItemMO = StickerItem(entity: entity!, insertIntoManagedObjectContext: context)

        stickerItemMO.frame = NSStringFromCGRect(stickerItem.frame)
        stickerItemMO.name = stickerItem.name
        stickerItemMO.zPosition = stickerItem.zPosition

        do {
            try context.save()
        } catch {
            print("ERROR: cannot save imageItem to context")
        }
        
        return stickerItemMO
    }*/
    
    /*static func saveCategoryToCoreData(category: Category) -> Category {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)
        
        let categoryMO = Category(entity: entity!, insertIntoManagedObjectContext: context)
        categoryMO.id = NSNumber(longLong: category.id)
        categoryMO.colour = category.colour
        categoryMO.name = category.name
        
        do{
            try context.save()
        } catch {
            print("ERROR: saving Category to context")
        }
        
        return categoryMO
    }*/
    
    static func saveCategoryIdIndexToCoreData(categoryIdIndex: CategoryIdIndexEntry) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("CategoryIdIndex", inManagedObjectContext: context)
        
        let categoryIdIndexMO = CategoryIdIndex(entity: entity!, insertIntoManagedObjectContext: context)
        categoryIdIndexMO.idToIndex = categoryIdIndex.idToIndex
        categoryIdIndexMO.indexToId = categoryIdIndex.indexToId
        
        do{
            try context.save()
        } catch {
            print("ERROR: saving CategoryIdIndex to context")
        }

    }

    
}

