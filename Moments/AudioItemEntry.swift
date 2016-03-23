//
//  AudioItemEntry.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class AudioItemEntry {
    let frame : CGRect!
    var url : NSURL?
    //let persistentID: Int64!
    let zPosition: Int!

    init(frame : CGRect, persistentID: Int64, zPosition: Int) {
        self.frame = frame
        //self.persistentID = persistentID
        self.zPosition = zPosition
    }
    
    init(audioItemMO: AudioItem) {
        self.frame = CGRectFromString(audioItemMO.frame!)
        self.url =  audioItemMO.url as? NSURL
        //self.persistentID = audioItemMO.persistentID!.longLongValue
        self.zPosition = audioItemMO.zPosition!.integerValue
    }
    
}