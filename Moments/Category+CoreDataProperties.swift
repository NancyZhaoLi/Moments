//
//  Category+CoreDataProperties.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-22.
//  Copyright © 2016 Moments. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged internal var colour: NSObject
    @NSManaged internal var id: NSNumber
    @NSManaged internal var name: String
    @NSManaged internal var userID: String
    @NSManaged var containedMoment: NSSet?

}
