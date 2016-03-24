//
//  Moment.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Moment: NSManagedObject {
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init?(backgroundColour: UIColor, favourite: Bool, title: String, category: Category) {
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
    }

    func getBackgroundColour() {
    
    }
    
    func setItemBackgroundColour(backgroundColour colour: UIColor) {
        self.backgroundColour = colour
    }
    
    func getDate() -> NSDate {
        return self.date
    }
    
    func getFavourite() {
        
    }
    
    func setItemFavourite() {
        
    }
    
    func getId() {
        
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    
    

}
