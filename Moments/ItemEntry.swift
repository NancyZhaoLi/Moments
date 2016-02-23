//
//  ItemEntry.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-22.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit


struct TextItemOtherAttribute {
    var colour : UIColor = UIColor.blackColor()
    // TO-DO: get the system default
    var font : UIFont = UIFont(name: "Arial", size: 2.0)!
  
    init(){}
  
    init(colour: UIColor, font: UIFont) {
        self.colour = colour
        self.font = font
    }
}

class ItemEntry {
  let id : Int64
  let type : Int
  var frame : CGRect
  var content : String?
  var rotation : Float = 0
  var otherAttribute : TextItemOtherAttribute = TextItemOtherAttribute()

  init(id : Int64, type : Int, frame : CGRect) {
    self.id = id
    self.type = type
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
