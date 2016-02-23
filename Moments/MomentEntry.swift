//
//  MomentEntry.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-22.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation

Class MomentEntry {
  var id : Int
  var date : NSDate
  var title: String
  
  var textItemId: [Int]?
  var imageItemId: [Int]?
  var audioItemId: [Int]?
  var videoItemId: [Int]?
  var stickerItemId: [Int]?

  var categoryName : String = "Uncategorized"
  var favourite : Bool = false
  var backgroundColour : UIColor = UIColor.whiteColor()
  
  init(id : Int, date: NSData, title: String) {
    self.id = id
    self.date = date
    self.title = title
  }
  
  func setIds(textItemId: [Int], imageItemId: [Int], audioItemId: [Int], videoItemId: [Int], stickerItemId : [Int]){
    self.textItemId = textItemId
    self.imageItemId = imageItemId
    self.audioItemId = audioItemId
    self.videoItemId = videoItemId
    self.stickerItemId = stickerItemId
  }
  
  func setBackgroundColour(colour: UIColor) {
    self.backgroundColour = colour
  }
  
  func setFavourite(favourite : Bool) {
    self.favourite = favourite
  }
  
  func setCategoryName(categoryName : String) {
    self.categoryName = categoryName
  }
  
}
