//
//  Category+CoreDataProperties.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var colour: NSObject?
    @NSManaged var name: String?
    @NSManaged var containedMoment: NSOrderedSet?

}
