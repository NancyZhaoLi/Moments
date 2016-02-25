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
    
    static var context: NSManagedObjectContext?
    
    init() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        CoreDataFetchHelper.context =  appDel.managedObjectContext
    }
    
    static func fetchMomentsMOFromCoreData() -> [NSManagedObject] {
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.returnsObjectsAsFaults = false
        
        do {
            let results = try context!.executeFetchRequest(requestMoments) as? [NSManagedObject]

            return results!
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
}