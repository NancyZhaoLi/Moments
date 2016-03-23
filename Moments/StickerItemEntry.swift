//
//  StickerItemEntry.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class StickerItemEntry {
    var frame : CGRect!
    var name : String!
    var zPosition: Int!
    
    init(name: String, frame: CGRect, zPosition: Int) {
        self.frame = frame
        self.name = name
        self.zPosition = zPosition
    }
    
    init(stickerItemMO: StickerItem) {
        self.name = stickerItemMO.name! as String
        self.frame = CGRectFromString(stickerItemMO.frame!)
        self.zPosition = stickerItemMO.zPosition!.integerValue
    }
    
}
