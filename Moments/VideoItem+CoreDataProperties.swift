//
//  VideoItem+CoreDataProperties.swift
//  Moments
//
//  Created by Nancy Li on 2016-03-28.
//  Copyright © 2016 Moments. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension VideoItem {

    @NSManaged var frame: String
    @NSManaged var url: NSObject
    @NSManaged var zPosition: NSNumber
    @NSManaged var snapshot: NSData
    @NSManaged var inMoment: Moment

}
