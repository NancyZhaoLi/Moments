//
//  ImageEntry.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class ImageItemEntry {
    let frame : CGRect!
    let image: UIImage!
    let rotation : Float!
    let zPosition: Int!
    
    init(frame : CGRect, image: UIImage, rotation: Float, zPosition: Int) {
        self.frame = frame
        self.image = image
        self.rotation = rotation
        self.zPosition = zPosition
    }
    
    init(imageItemMO: ImageItem) {
        self.frame = CGRectFromString(imageItemMO.frame!)
        self.rotation = imageItemMO.rotation!.floatValue
        self.image = UIImage(data: imageItemMO.image!)!
        self.zPosition = imageItemMO.zPosition!.integerValue
    }
}
