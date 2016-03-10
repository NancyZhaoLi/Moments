//
//  NewViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-19.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation
import CoreData

enum TouchMode : String {
    case Text = "Text",
         Image = "Image",
         Audio = "Audio",
         Video = "Video",
         Sticker = "Sticker",
         View = "View"
}

class NewMomentCanvasViewController: UIViewController,UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, EditTextItemViewControllerDelegate, MPMediaPickerControllerDelegate, ColourPickerViewControllerDelegate {
    
    let testMode : Bool = true
    var touchLocation : CGPoint?
    var touchMode : TouchMode = TouchMode.View
    
    var savePageAccessed : Bool = false
    var savePage : NewMomentSavePageViewController?
    var manager : NewMomentManager = NewMomentManager()
    var loadedMoment : MomentEntry?
    
    /*******************************************************************
     
        IBOUTLET AND IBACTION
     
     ******************************************************************/
    
    @IBOutlet weak var favouriteSetter: UIButton!
    @IBOutlet weak var addItemBar: UIToolbar!
    
    @IBAction func cancelAddNewMoment(sender: AnyObject) {
        debug("[cancelAddNewMoment] - cancel clicked")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addItem(sender: AnyObject) {
        debug("[addItem] - +Item Button Pressed")
        if (addItemBar.hidden) {
            displayAddItemBar()
        } else {
            hideAddItemBar()
        }
    }
    
    @IBAction func selectTouchMode(sender: AnyObject) {
        debug("[selectTouchMode] - one of the add type selected")
        if let title = sender.currentTitle {
            self.touchMode = TouchMode(rawValue: title!)!
            debug("[selectTouchMode] - mode selected: " + String(self.touchMode))
            if (title == "View" && !(addItemBar.hidden)) {
                hideAddItemBar()
            }
        }
    }
    
    @IBAction func setFav(sender: AnyObject) {
        debug("[otherOptions] - favourite Button pressed")
        if self.manager.setFavourite() {
            addToFavourite()
        } else {
            removeFromFavourite()
        }
    }
    
    func addToFavourite(){
        let image = UIImage(named: "FavouriteSelected") as UIImage?
        favouriteSetter.setBackgroundImage(image, forState: .Normal)
    }
    
    func removeFromFavourite() {
        let image = UIImage(named: "Favourite") as UIImage?
        favouriteSetter.setBackgroundImage(image, forState: .Normal)
    }
    
    
    
    @IBAction func goToSavePage(sender: AnyObject) {
        if (savePageAccessed) {
            print("presentView")
            presentViewController(self.savePage!, animated: true, completion: nil)
        } else {
            print("performSegue")
            performSegueWithIdentifier("newMomentToSavePageSegue", sender: self)
        }
    }
    
    func displayAddItemBar() {
        debug("[displayAddItemBar] - display bar")
        addItemBar.hidden = false
    }
    
    func hideAddItemBar() {
        debug("[hideAddItemBar] - hide bar")
        addItemBar.hidden = true
    }
    
    /*******************************************************************
     
        OVERRIDDEN UIVIEWCONTROLLER FUNCTIONS
     
     ******************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(246/255.0), alpha: 1.0)
        
        debug("[viewDidLoad] - loading start")
        if let moment = self.loadedMoment {
            manager.loadCanvas(self, moment: moment)
        } else {
            manager.setCanvas(self)
        }

        debug("[viewDidLoad] - loading complete")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches.isEmpty) {
            debug("[touchesBegan] - no touch")
        } else {
            debug("[touchesBegan] - begin")
            let touch = touches.first!
            self.touchLocation = touch.locationInView(touch.view)
            switch (self.touchMode) {
                case .Text:
                    addText()
                case .Image:
                    addImage()
                case .Audio:
                    addAudio()
                case .Video:
                    addVideo()
                case .Sticker:
                    addSticker()
                default:
                    break
            }
        }
        resetTouchMode()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditTextView" {
            let vc = segue.destinationViewController as! UINavigationController
            vc.modalPresentationStyle = .OverCurrentContext
            vc.delegate = self
        } else if segue.identifier == "showOtherOptionPopover" {
            print("OtherOptionPopover segue begin")
            let vc = segue.destinationViewController as! OtherCanvasOptionViewController
            vc.delegate = self
            let popoverVC = vc.popoverPresentationController
            popoverVC?.delegate = self
        } else if segue.identifier == "newMomentToSavePageSegue" {
            savePageAccessed = true
            self.savePage = segue.destinationViewController as! NewMomentSavePageViewController
            self.savePage!.canvas = self
            self.savePage!.manager = self.manager
        }
    }
    
    /*******************************************************************
     
        HELPER FUNCTIONS
     
     ******************************************************************/
    
    func backFromSavePage() {
        self.savePage!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func debug(msg: String) {
        if (self.testMode) {
            print("[NewMomentCanvasViewController] - " + msg)
        }
    }
    
    func resetTouchMode(){
        self.touchMode = TouchMode.View
    }
    
    func loadMoment(moment: MomentEntry) {
        self.loadedMoment = moment
    }
    
    
    func setCanvasBackground(controller: OtherCanvasOptionViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        let colourPickerVC = storyboard?.instantiateViewControllerWithIdentifier("colourPicker") as! ColourPickerViewController
        colourPickerVC.delegate = self
        self.presentViewController(colourPickerVC, animated: true, completion: nil)
    }
    
    /*******************************************************************
     
        ADD ITEM FUNCTIONS
     
     ******************************************************************/
    
    func addText(){
        self.performSegueWithIdentifier("showEditTextView", sender: self)
    }
    
    func addImage(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func addAudio(){
        let audio = MPMediaPickerController(mediaTypes: .AnyAudio)
        audio.delegate = self
        audio.allowsPickingMultipleItems = false
        self.presentViewController(audio, animated: true, completion: nil)
    }
    
    func addVideo(){
        let video = MPMediaPickerController(mediaTypes: .AnyVideo)
        video.delegate = self
        video.allowsPickingMultipleItems = false
        self.presentViewController(video, animated: true, completion: nil)
    }
    
    func addSticker() {

    }
    
    
    func loadText(textItem: TextItemViewController) {
        self.view.addSubview(textItem.view)
        self.addChildViewController(textItem)
    }
    
    func loadImage(imageItem: ImageItemViewController) {
        self.view.addSubview(imageItem.view)
        self.addChildViewController(imageItem)
    }
    
    func loadAudio(audioItem: AudioItemEntry) {
        
    }
    
    func loadVideo(videoItem: VideoItemEntry) {
        
    }
    
    func loadSticker(stickerItem: StickerItemEntry) {
        
    }
    
    func addNewViewController(vc: UIViewController) {
        self.view.addSubview(vc.view)
        self.addChildViewController(vc)
    }
    
    
    /*******************************************************************
    
        DELEGATE FUNCTIONS
    
     ******************************************************************/
     
    // EditTextItemViewControllerDelegate functions
    func addText(controller: EditTextItemViewController, text: String, textColour: UIColor, textFont: UIFont, textAlignment: NSTextAlignment) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        let vc = self.manager.addText(text, textColour: textColour, textFont: textFont, textAlignment:textAlignment, location: self.touchLocation!)
        addNewViewController(vc)
        resetTouchMode()
    }
    
    func cancelAddTextItem(controller: EditTextItemViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        resetTouchMode()
    }
    
    
    // Functions for UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Image Selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let vc = self.manager.addImage(image, location: self.touchLocation!, editingInfo: editingInfo)
        addNewViewController(vc)
    }
    
    
    // Functions for MPMediaPickerControllerDelegate
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("Video or audio selected")
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        if let mediaItem: MPMediaItem = mediaItemCollection.representativeItem {
            debug("[mediaPicker] - " + String(mediaItem))
            self.manager.addMediaItem(mediaItem, location: self.touchLocation!)
        } else {
            debug("[mediaPicker] - mediaItem not found")
        }
    }
    
    // Functions for UIPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    // Functions for ColourPickerViewControllerDelegate
    func selectColor(controller: ColourPickerViewController, colour: UIColor) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.view.backgroundColor = colour
    }
    
    func currentColor() -> UIColor {
        return self.view.backgroundColor!
    }
}