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
    var momentFavourite : Bool = false
    var momentCategory : CategoryEntry = CategoryEntry()
    var momentColour : UIColor = UIColor.whiteColor()
    var idPrefix : String = ""
    var idSuffix : String = ""
    
    var isNewMoment : Bool = true
    var testMode : Bool = true
    var debugPrefix : String = "[NewMomentManager] - "

    
    
    func setCanvas(canvas: NewMomentCanvasViewController) {
        self.canvas = canvas
        setIdPrefix()
        setIdSuffix()
        initItemManagers()
        setDefaultTitle()
    }
    
    func loadCanvas(canvas: NewMomentCanvasViewController, moment: MomentEntry) {
        self.canvas = canvas
        self.moment = moment
        self.momentDate = moment.date
        self.momentTitle = moment.title
        self.momentFavourite = moment.favourite
        
        if self.momentFavourite {
            self.canvas!.addToFavourite()
        }
        
        if let category = moment.category {
            self.momentCategory = category
        }
   
        self.momentColour = moment.backgroundColour
        self.canvas!.view.backgroundColor = self.momentColour
        self.idPrefix = String(moment.id / Int64(10000))
        self.idSuffix = String(moment.id % Int64(10000))
        self.isNewMoment = false

        initItemManagers()
        for textItem in moment.textItemEntries {
            debug("[loadCanvas] - textItem: " + String(textItem))
            self.canvas!.addNewViewController (textManager.loadText(textItem))
        }
        
        for imageItem in moment.imageItemEntries {
            self.canvas!.addNewViewController(imageManager.loadImage(imageItem))
        }
        
        for audioItem in moment.audioItemEntries {
            self.canvas!.addNewViewController(audioManager.loadAudio(audioItem))
        }
        
        for videoItem in moment.videoItemEntries {
            self.canvas!.addNewViewController(videoManager.loadVideo(videoItem))
        }
        
        for stickerItem in moment.stickerItemEntries {
            self.canvas!.addNewViewController(stickerManager.loadSticker(stickerItem))
        }
    }

    
    func setSavePage(savePage: NewMomentSavePageViewController) {
        self.savePage = savePage
        self.savePage!.setDefaultMomentTitle(self.momentTitle)
        self.savePage!.setDefaultMomentCategory(self.momentCategory.name)
    }
    
    func setFavourite() -> Bool {
        self.momentFavourite = !(self.momentFavourite)
        
        return self.momentFavourite
    }
    
    func initItemManagers(){
        self.textManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
        self.imageManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
        self.audioManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
        self.videoManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
        self.stickerManager.setCanvasAndManager(self.canvas!, manager: self, idPrefix: self.idPrefix)
    }
    
    func addText(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute) -> TextItemViewController {
        return self.textManager.addText(text, location: location, textAttribute: textAttribute)
    }
    
    func addImage(image: UIImage, location: CGPoint, editingInfo: [String : AnyObject]?) -> ImageItemViewController {
        return self.imageManager.addImage(image, location: location, editingInfo: editingInfo)
    }
    
    func addAudio(audioURL: NSURL, location: CGPoint) {
        self.audioManager.addAudio(audioURL, location: location)
    }
    
    func addMediaItem(mediaItem: MPMediaItem, location: CGPoint) {
        debug("[addMediaItem] called")
        //if mediaItem.mediaType == MPMediaType.AnyAudio {
            self.audioManager.addAudio(mediaItem)
        //} else if mediaItem.valueForProperty("MPMediaItemPropertyMediaType") as! String == MPMediaType.AnyVideo {
        //    self.videoManager.addVideo(mediaItem, location: location)
        //} else {
            //debug("[addMediaItem] - file not audio or video")
            //debug("mediaType: " + String(mediaItem.valueForProperty("MPMediaItemPropertyMediaType")))
        //}
    }
    
    func setDefaultTitle() {
        self.momentTitle = "Moment - " + self.momentDate.day + "/" + self.momentDate.month + "/" + self.momentDate.longYear
    }

    func setIdPrefix() {
        self.idPrefix = self.momentDate.shortYear + self.momentDate.month + self.momentDate.day
    }
    
    func setIdSuffix() {
        if let maxIdInCD : Int64 = CoreDataFetchHelper.requestMaxOfIdGreaterThan(Int64(self.idPrefix + "0000")!, entity: "Moment") {
            self.idSuffix = String(format: "%04lld", maxIdInCD + 1)
        } else {
            self.idSuffix = "0000"
        }
    }
    
    
    func saveMomentEntry() {
        updateTitle()
        updateColour()
        
        if self.isNewMoment {
            saveNewMoment()
        } else {
            if (CoreDataFetchHelper.deleteMomentGivenId(moment!.id)) {
                saveNewMoment()
            } else {
                debug("[saveMomentEntry] - could not delete old moment")
            }
        }
    }
    
    func saveNewMoment() {
        self.moment = MomentEntry.init(id: getId(), date: self.momentDate, title: self.momentTitle)
        if self.momentFavourite {
            self.moment!.setFavourite(self.momentFavourite)
        }
        
        if updateColour() {
            self.moment!.setBackgroundColour(self.momentColour)
        }
        
        self.moment!.category = self.momentCategory
        self.moment!.backgroundColour = self.canvas!.currentColor()
        
        self.textManager.notifySaveMoment()
        self.imageManager.notifySaveMoment()
        self.audioManager.notifySaveMoment()
        self.videoManager.notifySaveMoment()
        self.stickerManager.notifySaveMoment()
        debugEnd("saveMomentEntry")
    }
    
    
    func updateTitle() {
        self.momentTitle = self.savePage!.getTitle()
    }
    
    func updateColour() -> Bool {
        return false
    }
    
    
    func getId() -> Int64 {
        let id = Int64(self.idPrefix + self.idSuffix)!
        return id
    }

    func addTextItemEntry(entry: TextItemEntry) {
        self.moment!.addTextItemEntry(entry)
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
    
    func getIsNewMoment() -> Bool {
        return self.isNewMoment
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