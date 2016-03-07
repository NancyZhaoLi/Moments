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
    var category: CategoryEntry?
  
    init(id: Int64, date: NSDate, title: String) {
        self.id = id
        self.date = date
        self.title = title
    }
    
    init(momentMO: Moment) {
        self.id =  (momentMO.id?.longLongValue)!
        self.date = momentMO.date!
        self.title = momentMO.title!

        self.favourite = momentMO.favourite!.boolValue
        
        for textItemMO in momentMO.containedTextItem! {
            let textItem = TextItemEntry(textItemMO: textItemMO as! TextItem)
            addTextItemEntry(textItem)
        }
        
        for imageItemMO in momentMO.containedImageItem! {
            let imageItem = ImageItemEntry(imageItemMO: imageItemMO as! ImageItem)
            addImageItemEntry(imageItem)
        }
        
    }
  
    func setBackgroundColour(colour: UIColor) {
        self.backgroundColour = colour
    }
  
    func setFavourite(favourite : Bool) {
        self.favourite = favourite
    }
    
    func addTextItemEntry(text: TextItemEntry) {
        textItemEntries.append(text)
    }
    
    func addImageItemEntry(image: ImageItemEntry) {
        imageItemEntries.append(image)
    }
    
    func addAudioItemEntry(audio: AudioItemEntry) {
        audioItemEntries.append(audio)
    }
    
    func addVideoItemEntry(video: VideoItemEntry) {
        videoItemEntries.append(video)
    }
    
    func addStickerItemEntry(sticker: StickerItemEntry) {
        stickerItemEntries.append(sticker)
    }
    
    func setCategory(colour: UIColor, name: String) {
        self.category = CategoryEntry(colour: colour, name: name)
    }
    
}
