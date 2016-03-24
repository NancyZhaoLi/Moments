//
//  AudioMapping+CoreDataProperties.swift
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

extension AudioMapping {

    @NSManaged internal var audioURL: String
    @NSManaged internal var persistentID: String?
    @NSManaged var containedAudioItem: NSSet?

}
