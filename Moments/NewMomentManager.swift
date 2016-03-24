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
    var moment : Moment?
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
    
    init(canvasVC: NewMomentCanvasViewController, moment: Moment?) {
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
    
    func loadMoment(moment: Moment) {
        self.moment = moment
        momentDate = moment.getDate()
        momentTitle = moment.getTitle()
        momentFavourite = moment.getFavourite()
        
        if momentFavourite {
            //canvasVC.selectFavourite()
        }
        
        if let category = moment.getCategory() {
            momentCategory = category.getName()
        }
   
        momentColour = moment.getBackgroundColour()
        canvasVC.view.backgroundColor = self.momentColour
        idPrefix = String(moment.getMomentId() / Int64(10000))
        idSuffix = String(moment.getMomentId() % Int64(10000))
        isNewMoment = false

        for textItem in moment.getAllSavedText() {
            canvasVC.addNewViewController(loadText(textItem), zPosition: textItem.getZPosition())
        }
        
        for imageItem in moment.getAllSavedImage() {
            canvasVC.addNewViewController(loadImage(imageItem), zPosition: imageItem.getZPosition())
        }
        
        /*for audioItem in moment.audioItemEntries {
            canvasVC.addNewViewController(loadAudio(audioItem), zPosition: audioItem.zPosition)
        }
        
        for videoItem in moment.videoItemEntries {
            canvasVC.addNewViewController(loadVideo(videoItem))
        }*/
        
        for stickerItem in moment.getAllSavedSticker() {
            canvasVC.addNewViewController(loadSticker(stickerItem), zPosition: stickerItem.getZPosition())
        }
    }

    
    func loadText(textItem: TextItem) -> TextItemViewController {
        let newTextVC = TextItemViewController(manager: self)
        newTextVC.addText(textItem)
        
        return newTextVC
    }
    
    func loadImage(imageItem: ImageItem) -> ImageItemViewController {
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
    
    func loadSticker(stickerItem: StickerItem) -> StickerItemViewController {
        let newStickerVC = StickerItemViewController(manager: self)
        newStickerVC.addSticker(stickerItem)
        return newStickerVC
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
            let audioPlayer = try AVAudioPlayer(contentsOfURL: audioURL)
            
            let audioItemVC: AudioItemViewController = AudioItemViewController(manager: self)
            audioItemVC.addPlayer(audioPlayer, location: location)
            return audioItemVC
        } catch {
            print("audio player cannot be created")
        }
        
        return nil
    }
    
    func addSticker(stickerName: String, location: CGPoint) -> StickerItemViewController {
        let newStickerVC = StickerItemViewController(manager: self)
        newStickerVC.addSticker(stickerName, location: location)
        
        return newStickerVC
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
        print("saving moment entry in manager")
        updateTitle()
        //canvasVC.trashController!.trashView.removeFromSuperview()
        let category = CoreDataFetchHelper.fetchCategoryGivenName(self.momentCategory)
        let backgroundColour = canvasVC.view.backgroundColor!
        let favourite = momentFavourite
        let title = momentTitle
        
        if self.isNewMoment {
            let moment = Moment(backgroundColour: backgroundColour, favourite: favourite, title: title, category: category)!
            saveMoment(moment)
        } else {
            //if (CoreDataFetchHelper.deleteMomentGivenId(moment!.getMomentId())) {
            //if true {
           /* if let moment = self.moment {
                moment.setMomentBackgroundColour(backgroundColour)
                moment.setMomentCategory(category)
                moment.setMomentFavourite(favourite)
                moment.setMomentTitle(title)
                saveMoment(moment)
            }*/
            
            if let moment = self.moment {
                if let context = moment.managedObjectContext {
                    context.deleteObject(moment)
                    do {
                        try context.save()
                    } catch {
                        print("ERROR: could not delete old moment")
                    }
                }
                
            }
            
            let moment = Moment(backgroundColour: backgroundColour, favourite: favourite, title: title, category: category)!
            saveMoment(moment)
            
            //} else {
            //   fatalError("[saveMomentEntry] - could not delete old moment")
           // }
        }
    }
    
    func saveMoment(moment: Moment) {
        for var zPosition = 0; zPosition < canvasVC.canvas.subviews.count; zPosition++ {
            let view = canvasVC.canvas.subviews[zPosition]
            if let view = view as? TextItemView {
                let entry = TextItem(content: view.text, frame: view.frame, otherAttribute: TextItemOtherAttribute(colour: view.textColor!, font: view.font!, alignment: view.textAlignment), rotation: 0.0, zPosition: zPosition)
                if entry != 	nil {
                    moment.addText(entry!)
                } else {
                    print("fail to create TextItem in saveNewMoment")
                }
            } else if let view = view as? ImageItemView {
                let imageItemEntry = ImageItem(frame: view.frame, image: view.image!, rotation: 0.0, zPosition: zPosition)
                if imageItemEntry != nil {
                    moment.addImage(imageItemEntry!)
                } else {
                     print("fail to create ImageItem in saveNewMoment")
                }
            } else if let view: StickerItemView = view as? StickerItemView {
                if let name = view.stickerName {
                    let stickerItemEntry = StickerItem(frame: view.frame, name: name, zPosition: zPosition)
                    if stickerItemEntry != nil {
                        moment.addSticker(stickerItemEntry!)
                    } else {
                        print("fail to create StickerItem in saveNewMoment")
                    }
                }
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