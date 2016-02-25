//
//  CoreDataFetchHelper.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CoreDataFetchHelper {
    
    static func fetchMomentsMOFromCoreData() -> [Moment] {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(requestMoments) as! [Moment]

            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
    static func requestMaxOfIdGreaterThan(minimum: Int64, entity: String) -> Int64? {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: entity)
        let sortDes = NSSortDescriptor(key: "id", ascending: false)
        
        request.sortDescriptors = [sortDes]
        request.predicate = NSPredicate(format: "id >= %lld", minimum)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                let result = results[0].valueForKey("id")!.longLongValue
                if entity == "Moment" {
                    return result % Int64("10000")!
                } else {
                    return result % ItemType.modValue
                }
            } else {
                print("[requestId] - no item")
                return nil
            }
        } catch {
            print("[getMaxId] - Fetching failed")
        }
        
        return nil
    }

    
}