//
//  AudioItem+CoreDataProperties.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-24.
//  Copyright © 2016 Moments. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension AudioItem {

    @NSManaged internal var frame: String
    @NSManaged internal var zPosition: NSNumber
    @NSManaged internal var inMoment: Moment?
    @NSManaged internal var audioMapping: AudioMapping?

}
