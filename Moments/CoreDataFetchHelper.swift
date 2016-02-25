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
    
}