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
//import Firebase

//let current_ref = Firebase(url:"http://momentsxmen.firebaseio.com/")
//let current_userId = ref.authData.uid

extension NSDate {
    var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }
    
    var endOfDay: NSDate {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startOfDay, options: NSCalendarOptions())!
    }
}



class CoreDataFetchHelper {
    
    static func fetchMomentsMOFromCoreData() -> [Moment] {
        let defaultFetchSize = 20
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.predicate = NSPredicate(format: "trashed = %@ && userID = %@", false, ref.authData.uid)
        //print("In FetchHelper now, " + ref.authData.uid)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        requestMoments.sortDescriptors = [sortDescriptor]
        requestMoments.returnsObjectsAsFaults = false
        requestMoments.fetchLimit = defaultFetchSize
        
        do {
            let results = try context.executeFetchRequest(requestMoments) as! [Moment]

            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
    static func fetchMomentsBeforeDateFromCoreData(beforeDate: NSDate) -> [Moment] {
        let defaultFetchSize = 20
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.predicate = NSPredicate(format: "date < %@ && trashed = %@ && userID = %@", beforeDate, false, ref.authData.uid)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        requestMoments.sortDescriptors = [sortDescriptor]
        requestMoments.returnsObjectsAsFaults = false
        requestMoments.fetchLimit = defaultFetchSize
        
        do {
            let results = try context.executeFetchRequest(requestMoments) as! [Moment]
            
            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
    static func fetchFavouriteMomentsFromCoreData() -> [Moment] {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.predicate = NSPredicate(format: "favourite = %@ && trashed = %@ && userID = %@", true, false, ref.authData.uid)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        requestMoments.sortDescriptors = [sortDescriptor]
        requestMoments.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(requestMoments) as! [Moment]
            
            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
    static func fetchTrashedMomentsFromCoreData() -> [Moment] {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.predicate = NSPredicate(format: "trashed = %@ && userID = %@", true, ref.authData.uid)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        requestMoments.sortDescriptors = [sortDescriptor]
        requestMoments.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(requestMoments) as! [Moment]
            
            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
    
    static func fetchDayMomentsMOFromCoreData(date: NSDate) -> [Moment] {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.predicate = NSPredicate(format: "date >= %@ && date <= %@ && trashed = %@ && userID = %@", date.startOfDay, date.endOfDay, false, ref.authData.uid)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        requestMoments.sortDescriptors = [sortDescriptor]
        requestMoments.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(requestMoments) as! [Moment]
            
            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
    static func fetchDateRangeMomentsMOFromCoreData(start: NSDate, end: NSDate) -> [Moment] {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.predicate = NSPredicate(format: "date >= %@ && date <= %@ && trashed = %@ && userID = %@", start, end, false, ref.authData.uid)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        requestMoments.sortDescriptors = [sortDescriptor]
        requestMoments.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(requestMoments) as! [Moment]
            
            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    static func fetchCategoriesMOFromCoreData() -> [Category] {
        let defaultFetchSize = 20
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestCategories = NSFetchRequest(entityName: "Category")
        requestCategories.predicate = NSPredicate(format: "userID = %@", ref.authData.uid)
        requestCategories.returnsObjectsAsFaults = false
        requestCategories.fetchLimit = defaultFetchSize
        
        do {
            let results = try context.executeFetchRequest(requestCategories) as! [Category]
            
            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    static func fetchCategoryGivenName(name: String) -> Category {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext

        let requestCategory = NSFetchRequest(entityName: "Category")
        requestCategory.predicate = NSPredicate(format: "name = %@ && userID = %@", name, ref.authData.uid)
        requestCategory.returnsObjectsAsFaults = false
        requestCategory.fetchLimit = 1
        
        do {
            let result = try context.executeFetchRequest(requestCategory)[0] as! Category
            return result
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
        if entity == "Moment" {
            request.predicate = NSPredicate(format: "id >= %lld && trashed = %@ && userID = %@", minimum, false, ref.authData.uid)
        }else {
            request.predicate = NSPredicate(format: "id >= %lld && userID = %@", minimum, ref.authData.uid)
        }
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                let result = results[0].valueForKey("id")!.longLongValue
                //if entity == "Moment" {
                    return result % Int64("10000")!
                //} else {
                //    return result % ItemType.modValue
                //}
            } else {
                return nil
            }
        } catch {
            print("[getMaxId] - Fetching failed")
        }
        
        return nil
    }
    
    static func requestMaxCategoryId() -> Int64? {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Category")
        let sortDes = NSSortDescriptor(key: "id", ascending: false)
        
        request.sortDescriptors = [sortDes]
        request.predicate = NSPredicate(format: "userID = %@", ref.authData.uid)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                let id = results[0].valueForKey("id")!.longLongValue
                
                return id
            } else {
                return nil
            }
        } catch {
            print("[getMaxCategoryId] - Fetching failed")
        }
        
        return nil
    }
    
    static func fetchCategoryIdIndexFromCoreData() -> [CategoryIdIndex] {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "CategoryIdIndex")
        request.predicate = NSPredicate(format: "userID = %@", ref.authData.uid)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(request) as! [CategoryIdIndex]
            
            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
        
    // TODO: move this to delete helper class
    static func deleteMomentGivenId(id: Int64) -> Bool {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Moment")
        request.predicate = NSPredicate(format: "id == %lld && userID = %@", id, ref.authData.uid)
        
        do {
            let results = try context.executeFetchRequest(request)
            if results.count > 0 {
                context.deleteObject(results[0] as! NSManagedObject)
                return true
            } else {
               return false
            }
        } catch {
            print("[getMaxId] - Fetching failed")
            return false
        }

    }
    
    static func fetchDayMomentsCountFromCoreData(date: NSDate) -> Int {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Moment")
        request.predicate = NSPredicate(format: "date >= %@ && date <= %@ && trashed = %@  && userID = %@", date.startOfDay, date.endOfDay, false, ref.authData.uid)
        request.returnsObjectsAsFaults = true
        
        do {
            let results = try context.executeFetchRequest(request)
            
            return results.count
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    


}