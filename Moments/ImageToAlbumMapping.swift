//
//  ImageToAlbumMapping.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ImageToAlbumMapping: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(albumURL: NSURL){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("ImageToAlbumMapping", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setItemAlbumURL(albumURL)
            generateImageURL()
        } else {
            super.init()
            return nil
        }
    }
    
    func setItemAlbumURL(albumURL: NSURL) {
        self.albumURL = albumURL.absoluteString
    }
    
    private func generateImageURL() {
        let newUUIDString = NSUUID().UUIDString + ".jpeg"
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]

        let newImageURL = NSURL(fileURLWithPath: documentsPath).URLByAppendingPathComponent("images", isDirectory: true).URLByAppendingPathComponent(newUUIDString, isDirectory: false)
        self.imageURL = newImageURL.absoluteString
    }
    
    func getImageURL() -> NSURL? {
        return NSURL(string: imageURL)
    }
    
    static func fetchImageURLGivenAlbumURL(albumURL: NSURL) -> NSURL? {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "ImageToAlbumMapping")
        //request.resultType = .DictionaryResultType
        request.propertiesToFetch = NSArray(object: "imageURL") as [AnyObject]
        request.predicate = NSPredicate(format: "albumURL = %@", albumURL.absoluteString)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1

        do {
            let results  = try context.executeFetchRequest(request) as! [ImageToAlbumMapping]

            if results.count == 0 {
                let newMapping = ImageToAlbumMapping(albumURL: albumURL)
                if let newMapping = newMapping {
                    do {
                        try context.save()
                        return newMapping.getImageURL()
                    } catch {
                        print("ERROR: saving new image to album mapping")
                    }
                }
            } else {
                return results[0].getImageURL()
            }
        } catch {
            print("Failure to fetch context: \(error)")
        }
        return nil
    }

}
