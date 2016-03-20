//
//  CoreDataDeleteHelper.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-20.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CoreDataDeleteHelper {
    
    static func deleteCategoriesMOFromCoreData(categoryMO: Category) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext

        context.deleteObject(categoryMO)
        
        do {
            try context.save()
        } catch {
            print("ERROR: cannot delete category in core data")
        }
        
    }
}