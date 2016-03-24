//
//  ImageItem.swift
//  Moments
//
//  Created by Xin Lin and Yuning Xue on 2016-03-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class ImageItem: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(frame : CGRect, image: UIImage, rotation: Float, zPosition: Int) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("ImageItem", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: nil)
            setItemFrame(frame)
            setItemImage(image)
            setItemRotation(rotation)
            setItemZPosition(zPosition)
        } else {
            super.init()
            print("ERROR: entity not found for ImageItem")
            return nil
        }
    }
    
    func getFrame() -> CGRect {
        return CGRectFromString(self.frame)
    }
    
    func setItemFrame(frame: CGRect) {
        self.frame = NSStringFromCGRect(frame)
    }
    
    func getImage() -> UIImage? {
        return UIImage(data: self.image)
    }
    
    func setItemImage(image: UIImage) {
        self.image = UIImageJPEGRepresentation(image, 1.0)!
    }
    
    func getRotation() -> Float {
        return self.rotation.floatValue
    }
    
    func setItemRotation(rotation: Float) {
        self.rotation = NSNumber(float: rotation)
    }
    
    func getZPosition() -> Int {
        return self.zPosition.integerValue
    }
    
    func setItemZPosition(zPosition: Int) {
        self.zPosition = NSNumber(integer: zPosition)
    }
}
