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
    let id: Int64
    var frame : CGRect
    var url : NSURL?
    var rotation : Float = 0
    
    init(id: Int64, frame : CGRect) {
        self.id = id
        self.frame = frame
    }
    
    func setURL(url: NSURL) {
        self.url = url
    }
    
    func setRotation(rotation : Float) {
        self.rotation = rotation
    }
    
    
}
