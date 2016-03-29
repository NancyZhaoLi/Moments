//
//  VideoItem.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Photos


class VideoItem: NSManagedObject {


    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(frame: CGRect, fileURL url: NSURL, snapshot: UIImage, zPosition: Int) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("VideoItem", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: nil)
            setItemFrame(frame)
            setItemZPosition(zPosition)
            self.snapshot = UIImageJPEGRepresentation(snapshot, 1.0)!
            self.url = url
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
    
    func getURL() -> NSURL? {
        return self.url as? NSURL
    }
    
    func getSnapshot() -> UIImage? {
        return UIImage(data: self.snapshot)
    }
    
    func save() {
        if let url = self.getURL() {
            let photoLibrary : PHPhotoLibrary = PHPhotoLibrary.sharedPhotoLibrary()
            photoLibrary.performChanges({
             let createAssetRequest: PHAssetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(url)!
             }, completionHandler: {(success: Bool, error: NSError?) in
             if let theError = error {
                print("Error saving video: \(theError)")
             } else {
                print("Successfully saved video")
             }})
        }
    }
    
}
