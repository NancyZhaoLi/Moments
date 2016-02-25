//
//  ItemEntry.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-22.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit


class TextItemOtherAttribute: NSObject {
    var colour : UIColor = UIColor.blackColor()
    // TO-DO: get the system default
    var font : UIFont = UIFont(name: "Arial", size: 2.0)!
  
    override init() {
        super.init()
    }
    
    init(colour: UIColor, font: UIFont) {
        super.init()
        self.colour = colour
        self.font = font
    }
}

class TextItemEntry {
    let id: Int64
    var frame : CGRect
    var content : String?
    var rotation : Float = 0
    var otherAttribute : TextItemOtherAttribute = TextItemOtherAttribute()

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
  
    func setOtherAttribute(colour: UIColor, font: UIFont) {
        self.otherAttribute.colour = colour
        self.otherAttribute.font = font
    }

}
