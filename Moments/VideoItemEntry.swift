//
//  VideoItemEntry.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class VideoItemEntry {
    var frame : CGRect
    var content : String?
    var rotation : Float = 0
    
    init(frame : CGRect) {
        self.frame = frame
    }
    
    func setContent(content: String) {
        self.content = content
    }
    
    func setRotation(rotation : Float) {
        self.rotation = rotation
    }
    
    
}