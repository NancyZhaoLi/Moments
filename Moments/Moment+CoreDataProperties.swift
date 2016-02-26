//
//  Moment+CoreDataProperties.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-25.
//  Copyright © 2016 Moments. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Moment {

    @NSManaged var backgroundColour: NSObject?
    @NSManaged var date: NSDate?
    @NSManaged var favourite: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var containedAudioItem: NSSet?
    @NSManaged var containedImageItem: NSSet?
    @NSManaged var containedStickerItem: NSSet?
    @NSManaged var containedTextItem: NSSet?
    @NSManaged var containedVideoItem: NSSet?
    @NSManaged var inCategory: Category?

}
