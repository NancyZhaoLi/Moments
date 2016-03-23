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
    let id: Int64
    var title: String

    var favourite : Bool = false
    var backgroundColour : UIColor = UIColor.whiteColor()
    var textItemEntries = [TextItemEntry]()
    var imageItemEntries = [ImageItemEntry]()
    var audioItemEntries = [AudioItemEntry]()
    var videoItemEntries = [VideoItemEntry]()
    var stickerItemEntries = [StickerItemEntry]()
    var category: String?
  
    init(id: Int64, date: NSDate, title: String) {
        self.id = id
        self.date = date
        self.title = title
    }
    
    init(momentMO: Moment) {
        self.id =  momentMO.id!.longLongValue
        self.date = momentMO.date!
        self.title = momentMO.title!

        self.favourite = momentMO.favourite!.boolValue
        
        for textItemMO in momentMO.containedTextItem! {
            let textItem = TextItemEntry(textItemMO: textItemMO as! TextItem)
            addItemEntry(textItem)
        }
        
        for imageItemMO in momentMO.containedImageItem! {
            let imageItem = ImageItemEntry(imageItemMO: imageItemMO as! ImageItem)
            addItemEntry(imageItem)
        }
        
        for stickerItemMO in momentMO.containedStickerItem! {
            let stickerItem = StickerItemEntry(stickerItemMO: stickerItemMO as! StickerItem)
            addItemEntry(stickerItem)
        }
    }
  
    func setBackgroundColour(colour: UIColor) {
        self.backgroundColour = colour
    }
  
    func setFavourite(favourite : Bool) {
        self.favourite = favourite
    }
    
    func addItemEntry(text: TextItemEntry) {
        textItemEntries.append(text)
    }
    
    func addItemEntry(image: ImageItemEntry) {
        imageItemEntries.append(image)
    }
    
    func addItemEntry(audio: AudioItemEntry) {
        audioItemEntries.append(audio)
    }
    
    func addItemEntry(video: VideoItemEntry) {
        videoItemEntries.append(video)
    }
    
    func addItemEntry(sticker: StickerItemEntry) {
        stickerItemEntries.append(sticker)
    }
    
    func setCategory(name: String) {
        self.category = name
    }
    
}
