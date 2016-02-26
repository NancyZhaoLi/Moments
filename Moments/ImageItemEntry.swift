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
    let id: Int64
    var frame : CGRect
    var url : NSURL?
    var rotation : Float = 0
    var image: UIImage
    
    init(id: Int64, frame : CGRect, image: UIImage) {
        self.id = id
        self.frame = frame
        self.image = image
    }
    
    init(imageItemMO: ImageItem) {
        self.id = imageItemMO.id!.longLongValue
        self.frame = CGRectFromString(imageItemMO.frame!)
        //self.url = imageItemMO.url as! NSURL
        self.rotation = imageItemMO.rotation!.floatValue
        if let data = imageItemMO.image {
            self.image = UIImage(data: data)!
        } else {
            print("fail to get image from ImageItem")
        }
        self.image = UIImage(data: imageItemMO.image!)!
    }
    
    
    func setURL(url: NSURL) {
        self.url = url
    }
    
    func setRotation(rotation : Float) {
        self.rotation = rotation
    }
    
    
}
