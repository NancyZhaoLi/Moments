//
//  ImageItem.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class ImageItem: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
   /* init?() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("ImageItem", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            super.init()
            print("ERROR: entity not found for textItem")
            return nil
        }
    }*/
    
}
