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
    var momentCategory : Category = Category.fetchUncategorized()
    var momentColour : UIColor = UIColor.whiteColor()
    var idPrefix : String = ""
    var idSuffix : String = ""
    
    var isNewMoment : Bool = true
    var enableInteraction: Bool = true
    
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
    
    func setSavePage(savePage: NewMomentSavePageViewController) {
        self.savePage = savePage
        self.savePage!.setInitialMomentTitle(self.momentTitle)
        self.savePage!.setInitialMomentCategory(self.momentCategory)
        self.savePage!.setInitialMomentFavourite(self.momentFavourite)
    }
    
    
    /*********************************************************************************
     
        LOADING MOMENT FUNCTIONS
     *********************************************************************************/
    
    func loadMoment(moment: Moment) {
        self.moment = moment
        momentDate = moment.getDate()
        momentTitle = moment.getTitle()
        momentFavourite = moment.getFavourite()
        momentCategory = moment.getCategory()
        momentColour = moment.getBackgroundColour()
        
        canvasVC.view.backgroundColor = self.momentColour
        idPrefix = String(moment.getId() / Int64(10000))
        idSuffix = String(moment.getId() % Int64(10000))
        isNewMoment = false

        for textItem in moment.getAllSavedText() {
            let text = TextItemViewController(manager: self)!
            text.addItem(text: textItem)
        }
        
        for imageItem in moment.getAllSavedImage() {
            let image = ImageItemViewController(manager: self)!
            image.addItem(image: imageItem)
        }
        
        for audioItem in moment.getAllSavedAudio() {
            let audio = AudioItemViewController(manager: self)!
            audio.addItem(audio: audioItem)
        }
        
        for videoItem in moment.getAllSavedVideo() {
            let video = VideoItemViewController(manager: self)!
            video.addItem(video: videoItem)
        }
        
        for stickerItem in moment.getAllSavedSticker() {
            let sticker = StickerItemViewController(manager: self)!
            sticker.addItem(sticker: stickerItem)
        }
    }


    /*********************************************************************************
     
     NEW MOMENT ITEMS
     
     *********************************************************************************/
    
    func addText(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute){
        let newTextVC = TextItemViewController(manager: self)!
        newTextVC.addItem(text, location: location, textAttribute: textAttribute)
    }
    
    func addImage(image: UIImage, location: CGPoint) {
        let newImageVC = ImageItemViewController(manager: self)!
        newImageVC.addItem(image: image, location: location)
    }
    
    func addMusicAudio(music: MPMediaItem, location: CGPoint) {
        let audioItemVC: AudioItemViewController = AudioItemViewController(manager: self)!
        audioItemVC.addItem(musicItem: music, location: location)
    }
    
    func addRecordedAudio(fileURL url: NSURL, location: CGPoint)  {
        let audioItemVC: AudioItemViewController = AudioItemViewController(manager: self)!
        audioItemVC.addItem(recordingURL: url, location: location)
    }
    
    func addRecordedVideo(fileURL url: NSURL, location: CGPoint) {
        let videoItemVC: VideoItemViewController = VideoItemViewController(manager: self)!
        videoItemVC.addItem(videoURL: url, location: location)
    }
    
    func addSticker(stickerName: String, location: CGPoint){
        let newStickerVC = StickerItemViewController(manager: self)!
        newStickerVC.addItem(stickerName: stickerName, location: location)
    }

    
    func selectFavourite() {
        momentFavourite = true
    }
    
    func cancelFavourite() {
        momentFavourite = false
    }
    
    func cancelViewMode() {
        enableInteraction = true
        for vc in canvasVC.childViewControllers {
            if let vc = vc as? ItemViewController {
                vc.enableViewMode(false)
            }
        }
    }
    
    func selectViewMode() {
        enableInteraction = false
        for vc in canvasVC.childViewControllers {
            if let vc = vc as? ItemViewController {
                vc.enableViewMode(true)
            }
        }
    }
    
    func setEnabledOfTapToTrashGR(enabled:Bool) {
        for vc in canvasVC.childViewControllers {
            if let vc = vc as? ItemViewController {
                vc.enableTrash(enabled)
            }
        }
    }
    
    /*********************************************************************************
     
     FUNCTIONS CALLED FOR NEW MOMENT
     *********************************************************************************/
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
        self.momentTitle = self.savePage!.getTitle()
        let category = momentCategory
        let backgroundColour = canvasVC.view.backgroundColor!
        let favourite = momentFavourite
        let title = momentTitle
        
        if self.isNewMoment {
            let moment = Moment(backgroundColour: backgroundColour, favourite: favourite, title: title, category: category)!
            saveMoment(moment)
        } else if let moment = self.moment {
            moment.deleteContent()
            moment.setMomentBackgroundColour(backgroundColour)
            moment.setMomentCategory(category)
            moment.setMomentFavourite(favourite)
            moment.setMomentTitle(title)
            saveMoment(moment)
        }
    }
    
    func saveMoment(moment: Moment) {
        for var zPosition = 0; zPosition < canvasVC.canvas.subviews.count; zPosition+=1 {
            let view = canvasVC.canvas.subviews[zPosition]
            
            if let view = view as? TextItemView {
                if let text = TextItem(content: view.text, frame: view.frame, otherAttribute: TextItemOtherAttribute(colour: view.textColor!, font: view.font!, alignment: view.textAlignment), rotation: Float(view.rotation), zPosition: zPosition) {
                    moment.addText(text)
                } else {
                    print("ERROR: fail to create TextItem in saveNewMoment")
                }
            } else if let view = view as? ImageItemView {
                let rotation = Float(view.rotation)
                print("saving image item with rotation \(rotation)")
                if let image = ImageItem(frame: view.frame, image: view.image!, rotation: Float(view.rotation), zPosition: zPosition) {
                    moment.addImage(image)
                } else {
                     print("ERROR: fail to create ImageItem in saveNewMoment")
                }
            } else if let view = view as? AudioItemView {
                print("audio item view")
                if let musicURL = view.musicURL, persistentID = view.persistentID {
                    if let audio = AudioItem(frame: view.frame, musicURL: musicURL, persistentID: persistentID, zPosition: zPosition) {
                        moment.addAudio(audio)
                    } else {
                        print("ERROR: fail to create music AudioItem in saveNewMoment")
                    }
                } else if let fileURL = view.fileURL {
                    if let audio = AudioItem(frame: view.frame, fileURL: fileURL, zPosition: zPosition) {
                        moment.addAudio(audio)
                    } else {
                        print("ERROR: fail to create recording AudioItem in saveNewMoment")
                    }
                } else {
                    print("ERROR: url not set for AudioItem in saveNewMoment")
                }
            } else if let view = view as? VideoItemView {
                if let fileURL = view.fileURL, snapshot = view.image {
                    if let video = VideoItem(frame: view.frame, fileURL: fileURL, snapshot: snapshot, zPosition: zPosition) {
                        moment.addVideo(video)
                    } else {
                        print("ERROR: fail to create VideoItem in saveNewMoment")
                    }
                }
            } else if let view = view as? StickerItemView {
                if let name = view.stickerName {
                    if let sticker = StickerItem(frame: view.frame, name: name, zPosition: zPosition) {
                        moment.addSticker(sticker)
                    } else {
                        print("ERROR: fail to create StickerItem in saveNewMoment")
                    }
                }
            }
        }
        self.moment = moment
    }
    
    
    func addItemToCanvas(vc: UIViewController) {
        canvasVC.canvas.addSubview(vc.view)
        setupNewItem(vc)
    }
    
    func addItemToCanvas(vc: UIViewController, zPosition: Int) {
        canvasVC.canvas.insertSubview(vc.view, atIndex: zPosition)
        vc.view.layer.zPosition = 0.0
        setupNewItem(vc)
    }
    
    private func setupNewItem(vc: UIViewController) {
        vc.view.multipleTouchEnabled = true
        vc.view.userInteractionEnabled = true
        canvasVC.addChildViewController(vc)
    }
    
    
    func trashGR(vc: UIViewController) -> UITapGestureRecognizer {
        let trashGR = UITapGestureRecognizer(target: vc, action: "tapToTrash:")
        trashGR.enabled = false
        return trashGR
    }
    
    func dragGR() -> UIPanGestureRecognizer {
        let dragGR = UIPanGestureRecognizer(target: canvasVC, action: "draggedView:")
        dragGR.enabled = enableInteraction
        return dragGR
    }
    
    func pinchGR() -> UIPinchGestureRecognizer {
        let pinchGR = UIPinchGestureRecognizer(target: canvasVC, action: "pinchedView:")
        pinchGR.enabled = enableInteraction
        return pinchGR
    }
    
    func pinchTextGR() -> UIPinchGestureRecognizer {
        let pinchGR = UIPinchGestureRecognizer(target: canvasVC, action: "pinchedTextView:")
        
        pinchGR.enabled = enableInteraction
        return pinchGR
    }
    
    func rotateGR() -> UIRotationGestureRecognizer {
        let rotateGR = UIRotationGestureRecognizer(target: canvasVC, action: "rotateView:")
        rotateGR.enabled = enableInteraction
        return rotateGR
    }
    
    
    func presentViewController(vc: UIViewController, animated: Bool) {
        canvasVC.presentViewController(vc, animated: true)
    }
    
    /*func selectedCategoryName() -> String {
        return self.savePage!.selectedCell!.textLabel!.text!
    }
    
    func getId() -> Int64 {
        let id = Int64(self.idPrefix + self.idSuffix)!
        return id
    }*/
    
}