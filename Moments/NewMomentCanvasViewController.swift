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

class NewMomentCanvasViewController: UIViewController,
    UIPopoverPresentationControllerDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    EditTextItemViewControllerDelegate,
    MPMediaPickerControllerDelegate,
    ColourPickerViewControllerDelegate,
    AudioRecorderViewControllerDelegate,
    NewItemViewControllerDelegate {
    
    var savePage : NewMomentSavePageViewController?
    var manager : NewMomentManager = NewMomentManager()
    var loadedMoment : MomentEntry?
    var addItemPopover: NewItemViewController?
    var center: CGPoint = CGPointMake(windowWidth/2.0, windowHeight/2.0)
    
    var nextButton: UIButton! = UIButton()
    var viewButton: UIButton! = UIButton()
    var favouriteButton: UIButton! = UIButton()
    var settingButton: UIButton! = UIButton()
    
    /*******************************************************************
     
        OVERRIDDEN UIVIEWCONTROLLER FUNCTIONS
     
     ******************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.customBackgroundColor()
        
        if let moment = self.loadedMoment {
            manager.loadCanvas(self, moment: moment)
        } else {
            manager.setCanvas(self)
        }
        
        initUI()
    }
    
    func initUI() {
        addItemPopover = NewItemViewController(sourceView: self.view, delegate: self)
        
        let cancelButton = UIButton(frame: CGRectMake(0,3,60,37))
        cancelButton.addTarget(self, action: "cancelAddNewMoment", forControlEvents: .TouchUpInside)
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        nextButton = UIButton(frame: CGRectMake(windowWidth - 58,3,55,37))
        nextButton.addTarget(self, action: "goToSavePage", forControlEvents: .TouchUpInside)
        nextButton.setTitle("Next", forState: .Normal)
        nextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        let addButton = UIButton(frame: CGRectMake(0,0,40,40))
        addButton.center = CGPointMake(20 + (windowWidth-40)/8, 30)
        addButton.setBackgroundImage(UIImage(named: "add_icon.png")!, forState: .Normal)
        addButton.addTarget(self, action: "addItem", forControlEvents: .TouchUpInside)
        
        viewButton = UIButton(frame: CGRectMake(0,0,40,40))
        viewButton.center = CGPointMake(20 + (windowWidth-40) * 3/8, 30)
        cancelViewMode()
        
        settingButton = UIButton(frame: CGRectMake(0,0,40,40))
        settingButton.center = CGPointMake(20 + (windowWidth-40) * 5/8, 30)
        settingButton.setBackgroundImage(UIImage(named: "setting_icon.png")!, forState: .Normal)
        settingButton.addTarget(self, action: "setting", forControlEvents: .TouchUpInside)
        
        favouriteButton = UIButton(frame: CGRectMake(0,0,40,40))
        favouriteButton.center = CGPointMake(20 + (windowWidth-40) * 7/8, 30)
        cancelFavourite()
        
        let toolBar = UIToolbar(frame: CGRectMake(0,windowHeight - 60, windowWidth, 60))
        toolBar.barTintColor = UIColor.customBlueColor()
        toolBar.opaque = true
        toolBar.addSubview(addButton)
        toolBar.addSubview(viewButton)
        toolBar.addSubview(settingButton)
        toolBar.addSubview(favouriteButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.view.addSubview(toolBar)
    }
    
    
    func addItem() {
        if let popover = self.addItemPopover {
            presentViewController(popover, animated: true, completion: nil)
        }
    }
    
    func cancelViewMode() {
        viewButton.setBackgroundImage(UIImage(named: "view_close_icon.png")!, forState: .Normal)
        viewButton.removeTarget(self, action: "cancelViewMode", forControlEvents: .TouchUpInside)
        viewButton.addTarget(self, action: "selectViewMode", forControlEvents: .TouchUpInside)
        enableUserInteraction()
    }
    
    func selectViewMode() {
        viewButton.setBackgroundImage(UIImage(named: "view_open_icon.png")!, forState: .Normal)
        viewButton.removeTarget(self, action: "selectViewMode", forControlEvents: .TouchUpInside)
        viewButton.addTarget(self, action: "cancelViewMode", forControlEvents: .TouchUpInside)
        disableUserInteraction()
    }

    func enableUserInteraction() {
        for vc in self.childViewControllers {
            vc.view.userInteractionEnabled = true
        }
    }
    
    func disableUserInteraction() {
        for vc in self.childViewControllers {
            vc.view.userInteractionEnabled = false
        }
    }
    
    func cancelFavourite() {
        favouriteButton.setBackgroundImage(UIImage(named: "favourite_unselected_icon.png")!, forState: .Normal)
        favouriteButton.removeTarget(self, action: "cancelFavourite", forControlEvents: .TouchUpInside)
        favouriteButton.addTarget(self, action: "selectFavourite", forControlEvents: .TouchUpInside)
        self.manager.setFavourite()
    }
    
    func selectFavourite() {
        favouriteButton.setBackgroundImage(UIImage(named: "favourite_selected_icon.png")!, forState: .Normal)
        favouriteButton.removeTarget(self, action: "selectFavourite", forControlEvents: .TouchUpInside)
        favouriteButton.addTarget(self, action: "cancelFavourite", forControlEvents: .TouchUpInside)
        self.manager.setFavourite()
    }
    
    func setting() {
        presentViewController(OtherCanvasOptionViewController(sourceView:settingButton, delegate: self), animated: true, completion: nil)
    }
    
    func cancelAddNewMoment() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.removeFromParentViewController()
        self.removeFromParentViewController()
    }
    
    func goToSavePage() {
        performSegueWithIdentifier("showSavePage", sender: self)
    }
    
    func loadSavePage() {
        if let navController = self.navigationController {
            navController.pushViewController(savePage!, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addText" {
            let vc = segue.destinationViewController as! EditTextItemViewController
            vc.delegate = self
        } else if segue.identifier == "addSticker" {
            
        } else if segue.identifier == "showSavePage" {
            self.savePage = segue.destinationViewController as? NewMomentSavePageViewController
            self.savePage!.canvas = self
            self.savePage!.manager = self.manager
            nextButton.removeTarget(self, action: "goToSavePage", forControlEvents: .TouchUpInside)
            nextButton.addTarget(self, action: "loadSavePage", forControlEvents: .TouchUpInside)
        } else if segue.identifier == "newAudioRecording" {
            let vc = segue.destinationViewController as! AudioRecorderViewController
            vc.delegate = self
            let popoverVC = vc.popoverPresentationController
            popoverVC?.delegate = self
            popoverVC?.sourceRect = CGRectMake(20,20,0,0)
        }
    }
    
    /*******************************************************************
     
        HELPER FUNCTIONS
     
     ******************************************************************/
    
    func backFromSavePage() {
        self.savePage!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadMoment(moment: MomentEntry) {
        self.loadedMoment = moment
    }
    
    
    func setCanvasBackground(controller: OtherCanvasOptionViewController) {
        let colourPickerVC: ColourPickerViewController = ColourPickerViewController(initialColour: self.view.backgroundColor, delegate: self)
        self.presentViewController(colourPickerVC, animated: true, completion: nil)
    }
    
    /*******************************************************************
     
        ADD ITEM FUNCTIONS
     
     ******************************************************************/
    
    func addText() {
        self.performSegueWithIdentifier("addText", sender: self)
    }
    
    func addImageFromGallery() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func addImageFromCamera() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func addAudioFromRecorder(){
        let audioRecorder = AudioRecorderViewController(sourceView: self.view, delegate: self)
        
        self.performSegueWithIdentifier("newAudioRecording", sender: self)
    }

    func addAudioFromMusic() {
        
    }

    
    func addVideoFromCamera(){
        let video = MPMediaPickerController(mediaTypes: .AnyVideo)
        video.delegate = self
        video.allowsPickingMultipleItems = false
        self.presentViewController(video, animated: true, completion: nil)
    }
    
    func addVideoFromYoutube() {
    
    }
    
    func addSticker() {
        self.performSegueWithIdentifier("addSticker", sender: self)
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
    
    func addNewViewController(vc: UIViewController, zPosition: Int) {
        self.view.insertSubview(vc.view, atIndex: zPosition)
        vc.view.layer.zPosition = 0.0
        self.addChildViewController(vc)
    }
    
    /*******************************************************************
    
        DELEGATE FUNCTIONS
    
     ******************************************************************/
     
    // EditTextItemViewControllerDelegate functions
    func addText(controller: EditTextItemViewController, text: String, textAttribute: TextItemOtherAttribute) {
        print("1")
        addNewViewController(self.manager.addText(text, location: self.center, textAttribute: textAttribute))
    }
    
    func cancelAddTextItem(controller: EditTextItemViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Functions for UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("Image Selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let vc = self.manager.addImage(image, location: self.center, editingInfo: editingInfo)
        addNewViewController(vc)
    }
    
    // Functions for MPMediaPickerControllerDelegate
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("Video or audio selected")
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        print("Media item collection count: " + String(mediaItemCollection.count))
        print("Media item collection items: " + String(mediaItemCollection.items))
        print("Media item collection type: " + String(mediaItemCollection.mediaTypes))
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

    
    // Functions for AudioRecorderViewController Delegate
    func saveRecording(controller: AudioRecorderViewController, url: NSURL) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.manager.addAudio(url, location: self.center)
    }
}