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
    
    func getAllSavedMoments() -> [Moment] {
        if let savedMoments = self.containedMoment {
            return savedMoments.allObjects as! [Moment]
        }
        
        return [Moment]()
    }
    
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
            context.deleteObject(self)
            do {
                try context.save()
                return true
            } catch {
                print("ERROR: fail to delete moment")
            }
        }
        return false
    }
    
}
