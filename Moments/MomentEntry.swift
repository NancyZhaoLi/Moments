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
    let date : NSDate
    var title: String

    var favourite : Bool = false
    var backgroundColour : UIColor = UIColor.whiteColor()
  
    init(date: NSDate, title: String) {
        self.date = date
        self.title = title
    }
  
    func setBackgroundColour(colour: UIColor) {
        self.backgroundColour = colour
    }
  
    func setFavourite(favourite : Bool) {
        self.favourite = favourite
    }
    
}
