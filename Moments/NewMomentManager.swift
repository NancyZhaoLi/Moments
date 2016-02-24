//
//  NewMomentManager.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import CoreData

extension NSDate {
    var month: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.stringFromDate(self)
    }
    var day: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(self)
    }
    var shortYear: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yy"
        return dateFormatter.stringFromDate(self)
    }
    var longYear: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.stringFromDate(self)
    }
}

class NewMomentManager {
    
    private var canvas : NewMomentCanvasViewController?
    private var savePage : NewMomentSavePageViewController?
    private var textManager : TextItemManager = TextItemManager()
    private var imageManager : ImageItemManager = ImageItemManager()
    private var audioManager : AudioItemManager = AudioItemManager()
    private var videoManager : VideoItemManager = VideoItemManager()
    private var stickerManager : StickerItemManager = StickerItemManager()
    
    
    // Moment Entry Data
    var momentDate : NSDate = NSDate()
    var momentTitle : String?
    var favourite : Bool = false
    var momentCategory : String = "Uncategorized"
    
    var moment : MomentEntry?
    var idPrefix : String?
    var idSuffix : String?

    
    // CoreData variables
    var context : NSManagedObjectContext?
    
    
    var testMode : Bool = true
    var debugPrefix : String = "[NewMomentManager] - "
    
    init() {}
    
    func setCanvas(canvas: NewMomentCanvasViewController) {
        self.canvas = canvas
        initItemManagers()
    }
    
    func setSavePage(savePage: NewMomentSavePageViewController) {
        self.savePage = savePage
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.context = appDel.managedObjectContext
        
        setDefaultCategory()
        setDefaultTitle()
        setIdPrefix()
        
        //getNewIds()
    }
    
    func setFavourite() -> Bool {
        self.favourite = !(self.favourite)
        
        return self.favourite
    }
    
    func initItemManagers(){
        self.textManager.setCanvasAndManager(self.canvas!, manager: self)
        self.imageManager.setCanvasAndManager(self.canvas!, manager: self)
        self.audioManager.setCanvasAndManager(self.canvas!, manager: self)
        self.videoManager.setCanvasAndManager(self.canvas!, manager: self)
        self.stickerManager.setCanvasAndManager(self.canvas!, manager: self)
    }
    
    func setItemManagersIDPrefix() {
        self.textManager.setIdPrefix(self.idPrefix!)
        self.imageManager.setIdPrefix(self.idPrefix!)
        self.audioManager.setIdPrefix(self.idPrefix!)
        self.videoManager.setIdPrefix(self.idPrefix!)
        self.stickerManager.setIdPrefix(self.idPrefix!)
    }
    
    func addText(textView: UITextView, location: CGPoint) {
        self.textManager.addText(textView, location: location)
    }
    
    func addImage(image: UIImage, location: CGPoint, editingInfo: [String : AnyObject]?){
        self.imageManager.addImage(image, location: location, editingInfo: editingInfo)
    }
    
    func addMediaItem(mediaItem: MPMediaItem, location: CGPoint) {
        debug("[addMediaItem] called")
        //if mediaItem.mediaType == MPMediaType.AnyAudio {
            self.audioManager.addAudio(mediaItem)
        //} else if mediaItem.valueForProperty("MPMediaItemPropertyMediaType") as! String == MPMediaType.AnyVideo {
        //    self.videoManager.addVideo(mediaItem, location: location)
        //} else {
            debug("[addMediaItem] - file not audio or video")
            debug("mediaType: " + String(mediaItem.valueForProperty("MPMediaItemPropertyMediaType")))
        //}
    }
    
    func setDefaultCategory() {
       self.savePage!.setMomentCategory(self.momentCategory)
    }
    
    func setDefaultTitle() {
        self.momentTitle = "Moment - " + self.momentDate.day + "/" + self.momentDate.month + "/" + self.momentDate.longYear
        self.savePage!.setMomentTitle(self.momentTitle!)
    }

    func setIdPrefix() {
        self.idPrefix = self.momentDate.shortYear + self.momentDate.month + self.momentDate.day
        setItemManagersIDPrefix()
    }
    
    func setBaseId() {
        if let maxIdInCD : Int64 = requestMaxOfIdGreaterThan(Int64(self.idPrefix! + "0000")!, entity: "Moment") {
            self.idSuffix = String(format: "%04lld", maxIdInCD)
        } else {
            self.idSuffix = "0000"
        }
    }
    
    func requestMaxOfIdGreaterThan(minimum: Int64, entity: String) -> Int64? {
        let request = NSFetchRequest(entityName: entity)
        let sortDes = NSSortDescriptor(key: "id", ascending: false)
        
        request.sortDescriptors = [sortDes]
        request.predicate = NSPredicate(format: "id >= %lld", minimum)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let results = try self.context!.executeFetchRequest(request)
            if results.count > 0 {
                return results[0] as! Int64
            } else {
                return nil
            }
        } catch {
            print("[getMaxId] - Fetching failed")
        }
        
        return nil
    }
    
    func saveMoment() {
        
    }
    
    func debug (msg: String) {
        if (self.testMode) {
            print(self.debugPrefix + msg)
        }
    }
    
}
    
/*
func getNewIds() {
let lastId : Int = getMaxId("Moment", type: nil) + 1

if (lastId >= 0) {
self.momentId = Int64(self.idPrefix! + String(format: "%04d", lastId))
print ("new momentId: " + String(self.momentId!))
} else {
print("failed to get new moment id")
}

self.textItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Text") + 1))
print("textItemId: " + String(self.textItemId))
self.imageItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Image") + 1))
print("imageItemId: " + String(self.imageItemId))
self.audioItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Audio") + 1))
print("audioItemId: " + String(self.audioItemId))
self.videoItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Video") + 1))
print("videoItemId: " + String(self.videoItemId))
self.stickerItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Sticker") + 1))
}


/*
@IBAction func saveMoment(sender: AnyObject) {

self.moment = MomentEntry(id: self.momentId!, date: self.momentDate, title: self.momentTitle!)
for subview in delegate!.view.subviews {
if let text = subview as? UITextView {
print("view: text")
print(subview)
var item = ItemEntry(id: self.textItemId!, type: 0, frame: subview.frame)
item.setContent(text.text)
item.setOtherAttribute(text.textColor!, font: text.font!)
self.textItemId = self.textItemId! + Int64(1)
} else if let image = subview as? ImageItemViewController {
print("view: image")
print(subview)
var item = ItemEntry(id: self.imageItemId!, type: 1, frame: image.frame)
item.setContent(image.url!)
}

}
}
*/*/
