//
//  ImageItem+CoreDataProperties.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-23.
//  Copyright © 2016 Moments. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ImageItem {

    @NSManaged internal var frame: String
    @NSManaged internal var image: NSData
    @NSManaged internal var rotation: NSNumber
    @NSManaged internal var zPosition: NSNumber
    @NSManaged var inMoment: Moment?

}
