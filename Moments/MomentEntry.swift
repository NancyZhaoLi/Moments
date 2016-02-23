//
//  MomentEntry.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-22.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class MomentEntry {
    let id : Int64
    let date : NSDate
    var title: String
  
    var textItemId: [Int64]?
    var imageItemId: [Int64]?
    var audioItemId: [Int64]?
    var videoItemId: [Int64]?
    var stickerItemId: [Int64]?

    var categoryName : String = "Uncategorized"
    var favourite : Bool = false
    var backgroundColour : UIColor = UIColor.whiteColor()
  
    init(id : Int64, date: NSDate, title: String) {
        self.id = id
        self.date = date
        self.title = title
    }
  
    func setIds(textItemId: [Int64], imageItemId: [Int64], audioItemId: [Int64], videoItemId: [Int64], stickerItemId : [Int64]){
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
