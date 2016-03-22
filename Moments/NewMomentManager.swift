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
    
    var canvasVC : NewMomentCanvasViewController!
    private var savePage : NewMomentSavePageViewController?
    
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
    
    convenience init(canvasVC: NewMomentCanvasViewController) {
        self.init(canvasVC: canvasVC, moment: nil)
    }
    
    init(canvasVC: NewMomentCanvasViewController, moment: MomentEntry?) {
        self.canvasVC = canvasVC
        if let moment = moment {
            loadMoment(moment)
        } else {
            newMoment()
        }
    }
    
    func newMoment() {
        setIdPrefix()
        setIdSuffix()
        setDefaultTitle()
    }
    
    /*********************************************************************************
     
        LOADING FROM PAST MOMENTS
     *********************************************************************************/
    
    func loadMoment(moment: MomentEntry) {
        self.moment = moment
        momentDate = moment.date
        momentTitle = moment.title
        momentFavourite = moment.favourite
        
        if momentFavourite {
            //canvasVC.selectFavourite()
        }
        
        if let category = moment.category {
            momentCategory = category
        }
   
        momentColour = moment.backgroundColour
        canvasVC.view.backgroundColor = self.momentColour
        idPrefix = String(moment.id / Int64(10000))
        idSuffix = String(moment.id % Int64(10000))
        isNewMoment = false

        for textItem in moment.textItemEntries {
            canvasVC.addNewViewController(loadText(textItem), zPosition: textItem.zPosition)
        }
        
        for imageItem in moment.imageItemEntries {
            canvasVC.addNewViewController(loadImage(imageItem), zPosition: imageItem.zPosition)
        }
        
        for audioItem in moment.audioItemEntries {
            canvasVC.addNewViewController(loadAudio(audioItem), zPosition: audioItem.zPosition)
        }
        
        for videoItem in moment.videoItemEntries {
            canvasVC.addNewViewController(loadVideo(videoItem))
        }
        
        for stickerItem in moment.stickerItemEntries {
            canvasVC.addNewViewController(loadSticker(stickerItem))
        }
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
    
    func addAudio(audioURL: NSURL, location: CGPoint) -> AudioItemViewController? {
        do {
            print("begin")
            let audioPlayer = try AVAudioPlayer(contentsOfURL: audioURL)
            
            let audioItemVC: AudioItemViewController = AudioItemViewController(manager: self)
            audioItemVC.addPlayer(audioPlayer, location: location)
            return audioItemVC
        } catch {
            print("audio player cannot be created")
        }
        
        return nil
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

    func setSavePage(savePage: NewMomentSavePageViewController) {
        self.savePage = savePage
        self.savePage!.setDefaultMomentTitle(self.momentTitle)
        self.savePage!.setDefaultMomentCategory(self.momentCategory)
    }
    
    func selectFavourite() {
        momentFavourite = true
    }
    
    func unselectFavourite() {
        momentFavourite = false
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
        //canvasVC.trashController!.trashView.removeFromSuperview()
        
        if self.isNewMoment {
            saveNewMoment()
        } else {
            if (CoreDataFetchHelper.deleteMomentGivenId(moment!.id)) {
                saveNewMoment()
            } else {
               fatalError("[saveMomentEntry] - could not delete old moment")
            }
        }
    }
    
    func saveNewMoment() {
        let moment = MomentEntry.init(id: getId(), date: self.momentDate, title: self.momentTitle)
        moment.setFavourite(momentFavourite)
        moment.category = self.momentCategory
        moment.backgroundColour = canvasVC.view.backgroundColor!
        
        for var zPosition = 0; zPosition < canvasVC.canvas.subviews.count; zPosition++ {
            let view = canvasVC.canvas.subviews[zPosition]
            if let view = view as? UITextView {
                let entry = TextItemEntry(content: view.text, frame: view.frame, otherAttribute: TextItemOtherAttribute(colour: view.textColor!, font: view.font!, alignment: view.textAlignment), rotation: 0.0, zPosition: zPosition)
                moment.addItemEntry(entry)
            } else if let view = view as? UIImageView {
                let imageItemEntry = ImageItemEntry(frame: view.frame, image: view.image!, rotation: 0.0, zPosition: zPosition)
                moment.addItemEntry(imageItemEntry)
            }
        }
        self.moment = moment
    }
    
    
    func selectedCategoryName() -> String {
        return self.savePage!.selectedCell!.textLabel!.text!
    }
    
    func updateTitle() {
        self.momentTitle = self.savePage!.getTitle()
    }
    
    func getId() -> Int64 {
        let id = Int64(self.idPrefix + self.idSuffix)!
        return id
    }
    
}