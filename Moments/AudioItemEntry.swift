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
    let id: Int64
    var frame : CGRect
    var content : String?
    var rotation : Float = 0
    
    init(id: Int64, frame : CGRect) {
        self.id = id
        self.frame = frame
    }
    
    func setContent(content: String) {
        self.content = content
    }
    
    func setRotation(rotation : Float) {
        self.rotation = rotation
    }
    
    
}