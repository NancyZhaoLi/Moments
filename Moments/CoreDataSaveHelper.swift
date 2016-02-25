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
    
    static var context: NSManagedObjectContext?
    
    init() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        CoreDataSaveHelper.context =  appDel.managedObjectContext
    }
    
    static func saveNewMomentToCoreData(moment:MomentEntry) {
        
        let newMomentEntity = NSEntityDescription.insertNewObjectForEntityForName("Moment", inManagedObjectContext: context!) as! Moment
        
        let backgroundColour: UIColor = moment.backgroundColour
        let date: NSDate  = moment.date
        let favourite: Bool = moment.favourite
        let id: Int64 = moment.id
        let title: String = moment.title
        //let textItemEntries: [TextItemEntry] = moment.textItemEntries
        //let imageItemEntries: [ImageItemEntry] = moment.imageItemEntries
        //let audioItemEntries: [AudioItemEntry] = moment.audioItemEntries
        //let videoItemEntries: [VideoItemEntry] = moment.videoItemEntries
        //let stickerItemEntries: [StickerItemEntry] = moment.stickerItemEntries
        //let category: CategoryEntry = moment.category!
        
        newMomentEntity.setValue(backgroundColour, forKey: "backgroundColour")
        newMomentEntity.setValue(date, forKey: "date")
        newMomentEntity.setValue(favourite, forKey: "favourite")
        newMomentEntity.setValue(NSNumber(longLong: id), forKey: "id")
        newMomentEntity.setValue(title, forKey: "title")
        //newMomentEntity.setValue(NSSet(array: textItemEntries), forKey: "containedTextItem")
        //newMomentEntity.setValue(NSSet(array: imageItemEntries), forKey: "containedImageItem")
        //newMomentEntity.setValue(NSSet(array: audioItemEntries), forKey: "containedAudioItem")
        //newMomentEntity.setValue(NSSet(array: videoItemEntries), forKey: "containedVideoItem")
        //newMomentEntity.setValue(NSSet(array: stickerItemEntries), forKey: "containedStickerItem")
        //newMomentEntity.setValue(category, forKey: "inCategory")
        
        // save it
        do{
            try context!.save()
        } catch {
            print("ERROR: saving context to Moment")
        }
        
    }
    
    func saveTextItemToCoreData(textItem: TextItemEntry) {
        
    }
    
}
