//
//  VideoItem+CoreDataProperties.swift
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

extension VideoItem {

    @NSManaged var content: String?
    @NSManaged var frame: NSObject?
    @NSManaged var rotation: NSNumber?
    @NSManaged var inMoment: Moment?

}
