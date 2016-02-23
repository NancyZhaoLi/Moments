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
  var font : String = "Arial"
  var size : Int = 10
  
  init(){}
  
  init(colour: UIColor, font: String, size: Int) {
    self.colour = colour
    self.font = font
    self.size = size
  }
}

class ItemEntry {
  let id : Int
  let type : Int
  var frame : CGRect
  var content : String?
  var rotation : Float = 0
  var otherAttribute : TextItemOtherAttribute = TextItemOtherAttribute()

  init(id : Int, type : Int, frame : CGRect) {
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
  
  func setOtherAttribute(otherAttr: TextItemOtherAttribute) {
    self.otherAttribute = otherAttr
  }

}
