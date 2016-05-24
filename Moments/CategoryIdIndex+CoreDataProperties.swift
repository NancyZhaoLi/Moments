//
//  CategoryIdIndex+CoreDataProperties.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-23.
//  Copyright © 2016 Moments. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CategoryIdIndex {

    @NSManaged var idToIndex: NSObject
    @NSManaged var indexToId: NSObject
    @NSManaged internal var userID: String
    

}
