//
//  Category.swift
//  Moments
//
//  Created by Xin Lin and Yuning Xue on 2016-03-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Category: NSManagedObject {

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)
        
        super.init(entity: entity!, insertIntoManagedObjectContext: nil)
    }
    
    init?(id: Int64, colour: UIColor, name: String) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setCategoryId(id)
            setCategoryColour(colour)
            setCategoryName(name)
            setCategoryUserId()
        } else {
            super.init()
            print("ERROR: entity not found for Category")
            return nil
        }
    }
    init?(id: Int64, colour: UIColor, name: String, userId: String) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setCategoryId(id)
            setCategoryColour(colour)
            setCategoryName(name)
            self.userID = userId
        } else {
            super.init()
            print("ERROR: entity not found for Category")
            return nil
        }
    }
    
    func getId() -> Int64 {
        return self.id.longLongValue
    }
    
    func setCategoryId(id: Int64) {
        self.id = NSNumber(longLong: id)
    }
    func setCategoryUserId(){
        self.userID =  ref.authData.uid
    }
    func getCategoryUserId() -> String {
        return self.userID
    }
    
    func getColour() -> UIColor {
        return self.colour as! UIColor
    }
    
    func setCategoryColour(colour: UIColor) {
        self.colour = colour
    }
    
    func getName() -> String {
        return self.name
    }
    
    func setCategoryName(name: String) {
        self.name = name
    }
    
    func addMoment(moment: Moment) {
        let moments = self.mutableSetValueForKey("containedMoment")
        moments.addObject(moments)
    }
    
    func getSavedMoments() -> [Moment] {
        if let savedMoments = self.containedMoment {
            var resultArray = savedMoments.allObjects as! [Moment]
            resultArray = filterForTrahsed(resultArray)
            resultArray = filterForUserId(resultArray)
            
            //return savedMoments.allObjects as! [Moment]
            return resultArray
        }
        
        return [Moment]()
    }
    
    func getSortedSavedMoments() -> [Moment] {
        if let savedMoments = self.containedMoment {
            let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            var momentArray: [Moment] = savedMoments.sortedArrayUsingDescriptors([sortDescriptor]) as! [Moment]
            momentArray = filterForTrahsed(momentArray)
            momentArray = filterForUserId(momentArray)
            return momentArray
        }
        
        return [Moment]()
    }
    //=========Monica add these for filting trashed moments and those moments under different userID===========
    
    func filterForTrahsed(allMoments: [Moment]) -> [Moment] {
        var resultArray = [Moment]()
        if allMoments.isEmpty == false {
            for index in 0...(allMoments.count-1){
                if allMoments[index].getTrashed() == false {
                    //allMoments.removeAtIndex(index)
                    resultArray.append(allMoments[index])
                }
            }
        }
        else {
            return allMoments
        }
        return resultArray
    }
    
    func filterForUserId(allMoments: [Moment]) -> [Moment] {
        var resultArray = [Moment]()
        if allMoments.isEmpty == false {
            for index in 0...(allMoments.count-1){
                if allMoments[index].getUserId() == ref.authData.uid {
                    //allMoments.removeAtIndex(index)
                    resultArray.append(allMoments[index])
                }
            }
        } else {return allMoments}
        return resultArray
    }
    
    //=========================End of Monica's filter==========================================================
    
    func save() {
        if let context = self.managedObjectContext {
            do {
                try context.save()
            } catch {
                print("ERROR: fail to save category")
            }
        }
    }
    
    func delete() -> Bool {
        if let context = self.managedObjectContext {
            let containedMoment = self.mutableSetValueForKey("containedMoment")
            for item in containedMoment {
                if let moment = item as? Moment, uncategorize = Category.getUncategorized() {
                    moment.setMomentCategory(uncategorize)
                }
            }

            context.deleteObject(self)
            do {
                try context.save()
                return true
            } catch {
                print("ERROR: fail to delete category")
            }
        }
        return false
    }
    
    static func getUncategorized() -> Category? {
        if let uncategorized = fetchCategoryGivenName("Uncategorized") {
            return uncategorized
        }
        
        return nil
    }
    
    static func fetchCategoryGivenName(name: String) -> Category? {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestCategory = NSFetchRequest(entityName: "Category")
        requestCategory.predicate = NSPredicate(format: "name = %@ && userID = %@", name, ref.authData.uid)
        requestCategory.returnsObjectsAsFaults = false
        requestCategory.fetchLimit = 1
        
        do {
            let results = try context.executeFetchRequest(requestCategory) as! [Category]
            if !results.isEmpty {
                let result = results[0]
                return result
            }
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
        return nil
    }
    
    static func fetchUncategorized() -> Category {
        return fetchCategoryGivenName("Uncategorized")!
    }
    
    static func fetchOtherCategories() -> [Category] {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestCategories = NSFetchRequest(entityName: "Category")
        requestCategories.predicate = NSPredicate(format: "name != %@ && name != %@ && userID = %@", "Uncategorized", "Favourite", ref.authData.uid)
        requestCategories.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(requestCategories) as! [Category]
            
            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
    }
    
    static func categoryNameExist(categoryName name: String) -> Bool {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestCategories = NSFetchRequest(entityName: "Category")
        requestCategories.predicate = NSPredicate(format: "name = %@ && userID = %@", name, ref.authData.uid)
        requestCategories.includesSubentities = false

        let err: NSErrorPointer = NSErrorPointer()
        let count = context.countForFetchRequest(requestCategories, error: err)
        if count == NSNotFound {
            return false
        } else if count == 0 {
            return false
        } else {
            return true
        }
    }
}
