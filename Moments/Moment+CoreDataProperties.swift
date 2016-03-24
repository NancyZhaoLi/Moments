//
//  Moment+CoreDataProperties.swift
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

extension Moment {

    @NSManaged internal var backgroundColour: NSObject
    @NSManaged internal var date: NSDate
    @NSManaged internal var favourite: NSNumber
    @NSManaged internal var id: NSNumber
    @NSManaged internal var title: String
    @NSManaged var containedAudioItem: NSSet?
    @NSManaged var containedImageItem: NSSet?
    @NSManaged var containedStickerItem: NSSet?
    @NSManaged var containedTextItem: NSSet?
    @NSManaged var containedVideoItem: NSSet?
    @NSManaged var inCategory: Category?

}
