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
    var moment : MomentEntry?
    var momentDate : NSDate = NSDate()
    var momentTitle : String = ""
    var favourite : Bool = false
    var momentCategory : CategoryEntry = CategoryEntry()
    var momentColour : UIColor = UIColor.whiteColor()
    var idPrefix : String = ""
    var idSuffix : String = ""
    
    // CoreData variables
    var context : NSManagedObjectContext?
    
    
    var testMode : Bool = true
    var debugPrefix : String = "[NewMomentManager] - "

    
    func setCanvas(canvas: NewMomentCanvasViewController) {
        self.canvas = canvas
        setContext()
        setIdPrefix()
        setIdSuffix()
        initItemManagers()
    }
    
    func setContext() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.context = appDel.managedObjectContext
    }
    
    func setSavePage(savePage: NewMomentSavePageViewController) {
        self.savePage = savePage
        setDefaultCategory()
        setDefaultTitle()
    }
    
    func setFavourite() -> Bool {
        self.favourite = !(self.favourite)
        
        return self.favourite
    }
    
    func initItemManagers(){
        self.textManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
        self.imageManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
        self.audioManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
        self.videoManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
        self.stickerManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
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
       self.savePage!.setMomentCategory(self.momentCategory.name)
    }
    
    func setDefaultTitle() {
        self.momentTitle = "Moment - " + self.momentDate.day + "/" + self.momentDate.month + "/" + self.momentDate.longYear
        self.savePage!.setMomentTitle(self.momentTitle)
    }

    func setIdPrefix() {
        self.idPrefix = self.momentDate.shortYear + self.momentDate.month + self.momentDate.day
    }
    
    func setIdSuffix() {
        if let maxIdInCD : Int64 = requestMaxOfIdGreaterThan(Int64(self.idPrefix + "0000")!, entity: "Moment") {
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
                return results[0].longLongValue
            } else {
                return nil
            }
        } catch {
            print("[getMaxId] - Fetching failed")
        }
        
        return nil
    }
    
    func saveMomentEntry() {
        debugBegin("saveMomentEntry")
        setIdPrefix()
        setIdSuffix()
        updateTitle()
        updateColour()
        self.moment = MomentEntry.init(id: getId(), date: self.momentDate, title: self.momentTitle)
        if self.favourite {
            self.moment!.setFavourite(self.favourite)
        }
        
        if updateColour() {
            self.moment!.setBackgroundColour(self.momentColour)
        }
        
        self.moment!.category = self.momentCategory
        
        self.textManager.notifySaveMoment()
        debug("[saveMomentEntry] - textManger notified")
        self.imageManager.notifySaveMoment()
        debug("[saveMomentEntry] - imageManger notified")
        self.audioManager.notifySaveMoment()
        debug("[saveMomentEntry] - audioManger notified")
        self.videoManager.notifySaveMoment()
        debug("[saveMomentEntry] - videoManger notified")
        self.stickerManager.notifySaveMoment()
        debugEnd("saveMomentEntry")
    }
    
    func updateTitle() {
        if let title = self.savePage!.momentTitleDisplay.text {
            if title.isEmpty {
                debug("[updateTitle] - empty text")
            } else {
                self.momentTitle = title
            }
        } else {
            debug("[updateTitle] - nil text")

        }
    }
    
    func updateColour() -> Bool {
        return false
    }
    
    func getId() -> Int64 {
        let id = Int64(self.idPrefix + self.idSuffix)!
        debugBegin("[getId] - id: " + String(id))
        return id
    }

    func addTextItemEntry(entry: TextItemEntry) {
        debugBegin("addTextItemEntry")
        self.moment!.addTextItemEntry(entry)
        debugEnd("addTextItemEntry")
    }
    
    func addImageItemEntry(entry: ImageItemEntry) {
        debugBegin("addImageItemEntry")
        self.moment!.addImageItemEntry(entry)
        debugEnd("addImageItemEntry")
    }
    
    func addAudioItemEntry(entry: AudioItemEntry) {
        debugBegin("addAudioItemEntry")
        self.moment!.addAudioItemEntry(entry)
        debugEnd("addAudioItemEntry")
    }
    
    func addVideoItemEntry(entry: VideoItemEntry) {
        debugBegin("addVideoItemEntry")
        self.moment!.addVideoItemEntry(entry)
        debugEnd("addVideoItemEntry")
    }
    
    func addStickerItemEntry(entry: StickerItemEntry) {
        debugBegin("addStickerItemEntry")
        self.moment!.addStickerItemEntry(entry)
        debugEnd("addStickerItemEntry")
    }
    
    func debug (msg: String) {
        if (self.testMode) {
            print(self.debugPrefix + msg)
        }
    }
    
    func debugBegin(fn: String) {
        if (self.testMode) {
            print(self.debugPrefix + "[" + fn + "] - begin")
        }
    }
    
    func debugEnd(fn: String) {
        if (self.testMode) {
            print(self.debugPrefix + "[" + fn + "] - end")
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
