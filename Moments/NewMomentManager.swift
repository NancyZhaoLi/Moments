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
    
    var canvas : NewMomentCanvasViewController?
    private var savePage : NewMomentSavePageViewController?
    /*private var textManager : TextItemManager = TextItemManager()
    private var imageManager : ImageItemManager = ImageItemManager()
    private var audioManager : AudioItemManager = AudioItemManager()
    private var videoManager : VideoItemManager = VideoItemManager()
    private var stickerManager : StickerItemManager = StickerItemManager()*/
    
    
    // Moment Entry Data
    var moment : MomentEntry?
    var momentDate : NSDate = NSDate()
    var momentTitle : String = ""
    var momentFavourite : Bool = false
    var momentCategory : String = "Uncategorized"
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
        setDefaultTitle()
    }
    
    /*********************************************************************************
     
        LOADING FROM PAST MOMENTS
     *********************************************************************************/
    
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

        for textItem in moment.textItemEntries {
            print(textItem)
            self.canvas!.addNewViewController(loadText(textItem), zPosition: textItem.zPosition)
        }
        
        for imageItem in moment.imageItemEntries {
            print(imageItem)
            self.canvas!.addNewViewController(loadImage(imageItem), zPosition: imageItem.zPosition)
        }
        
        for audioItem in moment.audioItemEntries {
            self.canvas!.addNewViewController(loadAudio(audioItem), zPosition: audioItem.zPosition)
        }
        
        for videoItem in moment.videoItemEntries {
            self.canvas!.addNewViewController(loadVideo(videoItem))
        }
        
        for stickerItem in moment.stickerItemEntries {
            self.canvas!.addNewViewController(loadSticker(stickerItem))
        }
        
        self.canvas!.enableUserInteraction()
    }

    
    func loadText(textItem: TextItemEntry) -> TextItemViewController {
        let newTextVC = TextItemViewController(manager: self)
        newTextVC.addText(textItem)
        
        return newTextVC
    }
    
    func loadImage(imageItem: ImageItemEntry) -> ImageItemViewController {
        let newImageVC = ImageItemViewController(manager: self)
        newImageVC.addImage(imageItem)
        
        return newImageVC
    }
    
    func loadAudio(audioItem: AudioItemEntry) -> AudioItemViewController {
        let newAudioVC = AudioItemViewController(manager: self)
        newAudioVC.addAudio(audioItem)
        
        return newAudioVC
    }
    
    func loadVideo(videoItem: VideoItemEntry) -> VideoItemViewController {
        return VideoItemViewController()
    }
    
    func loadSticker(stickerItem: StickerItemEntry) -> StickerItemViewController {
        return StickerItemViewController()
    }
    
    
    /*********************************************************************************
     
     NEW MOMENT ELEMENTS
     
     *********************************************************************************/
    
    func addText(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute) -> TextItemViewController {
        let newTextVC = TextItemViewController(manager: self)
        newTextVC.addText(text, location: location, textAttribute: textAttribute)
            
        return newTextVC
    }
    
    func addImage(image: UIImage, location: CGPoint, editingInfo: [String : AnyObject]?) -> ImageItemViewController {
        let newImageVC = ImageItemViewController(manager: self)
        newImageVC.addImage(image, location: location, editingInfo: editingInfo)
        
        return newImageVC
    }
    
    func addAudio(audioURL: NSURL, location: CGPoint) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOfURL: audioURL)
            if let audioItemVC: AudioItemViewController = canvas!.storyboard?.instantiateViewControllerWithIdentifier("audioPlayer") as? AudioItemViewController {
                audioItemVC.player = audioPlayer
                audioItemVC.manager = self
                audioItemVC.view.center = location
                
                canvas!.view.addSubview(audioItemVC.view)
                canvas!.addChildViewController(audioItemVC)
            }
        } catch {
            debug(debugPrefix + "audio player cannot be created")
        }
    }

    
    
    
    
    func setSavePage(savePage: NewMomentSavePageViewController) {
        self.savePage = savePage
        self.savePage!.setDefaultMomentTitle(self.momentTitle)
        self.savePage!.setDefaultMomentCategory(self.momentCategory)
    }
    
    func setFavourite() -> Bool {
        self.momentFavourite = !(self.momentFavourite)
        
        return self.momentFavourite
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
    
    /*********************************************************************************
     
     SAVING TO COREDATA
     
     *********************************************************************************/

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
        self.moment!.backgroundColour = self.canvas!.view.backgroundColor!
        
        for var zPosition = 0; zPosition < self.canvas!.view.subviews.count; zPosition++ {
            let view = self.canvas!.view.subviews[zPosition]
            if let view = view as? UITextView {
                let entry = TextItemEntry(content: view.text, frame: view.frame, otherAttribute: TextItemOtherAttribute(colour: view.textColor!, font: view.font!, alignment: view.textAlignment), rotation: 0.0, zPosition: zPosition)
                self.moment!.addItemEntry(entry)
            } else if let view = view as? UIImageView {
                let imageItemEntry = ImageItemEntry(frame: view.frame, image: view.image!, rotation: 0.0, zPosition: zPosition)
                self.moment!.addItemEntry(imageItemEntry)
            }
        }

        debugEnd("saveMomentEntry")
    }
    
    
    func selectedCategoryName() -> String {
        return self.savePage!.selectedCell!.textLabel!.text!
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

/*
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
    }*/
    
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