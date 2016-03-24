//
//  CoreDataSetHelper.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CoreDataSetHelper {
    
    static func setCategoryIdIndexInCoreData(categoryIdIndex: CategoryIdIndexEntry) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "CategoryIdIndex")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request) as! [CategoryIdIndex]
            
            results[0].setValue(categoryIdIndex.idToIndex, forKey: "idToIndex")
            results[0].setValue(categoryIdIndex.indexToId, forKey: "indexToId")
            
            do{
                try context.save()
            } catch {
                print("ERROR: setting CategoryIdIndex to context")
            }
            
        } catch {
            fatalError("Failure to set context: \(error)")
        }
        
        
        
    }
}