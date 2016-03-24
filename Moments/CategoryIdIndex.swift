//
//  CategoryIdIndex.swift
//  Moments
//
//  Created by Xin Lin and Yuning Xue on 2016-03-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData


class CategoryIdIndex: NSManagedObject {

    /*override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(idToIndex: NSMapTable, indexToId: NSMapTable) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("TextItem", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: nil)
            
        } else {
            super.init()
            print("ERROR: entity not found for TextItem")
            return nil
        }
        
        self.idToIndex = idToIndex
        self.indexToId = indexToId
    }*/


}
