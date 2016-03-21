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
    NewItemViewControllerDelegate,
    DragToTrashDelegate {
    
    var savePage : NewMomentSavePageViewController?
    var manager : NewMomentManager = NewMomentManager()
    var loadedMoment : MomentEntry?
    var addItemPopover: NewItemViewController?
    var center: CGPoint = CGPointMake(windowWidth/2.0, windowHeight/2.0)
    
    var nextButton: UIButton! = UIButton()
    var viewButton: UIButton! = UIButton()
    var favouriteButton: UIButton! = UIButton()
    var settingButton: UIButton! = UIButton()
    
    var trashController: DragToTrash?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.customBackgroundColor()
        
        if let moment = self.loadedMoment {
            manager.loadCanvas(self, moment: moment)
        } else {
            manager.setCanvas(self)
        }
        
        initUI()
        initTrash()
        
        if self.loadedMoment != nil {
            selectViewMode()
        }
    }
    
    func initUI() {
        let buttonSize: CGFloat = 40.0
        let toolBarHeight: CGFloat = 60.0
        
        let toolbarItemCenters = ToolbarHelper.getCenter(30.0, totalItems: 4, inset: 20.0)
        
        addItemPopover = NewItemViewController(sourceView: self.view, delegate: self)
        
        //Navigation Buttons
        let cancelButton = NavigationHelper.leftNavButton("Cancel", target: self, action: "cancelAddNewMoment")
        nextButton = NavigationHelper.rightNavButton("Next", target: self, action: "goToSavePage")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        //Toolbar Buttons
        let addButton = ButtonHelper.imageButton("add_icon.png", center: toolbarItemCenters[0], imageSize: buttonSize, target: self, action: "addItem")
        
        viewButton = UIButton(center: toolbarItemCenters[1], width: buttonSize)
        cancelViewMode()
        
        settingButton = ButtonHelper.imageButton("setting_icon.png", center: toolbarItemCenters[2], imageSize: buttonSize, target: self, action: "setting")

        favouriteButton = UIButton(center: toolbarItemCenters[3], width: buttonSize)
        cancelFavourite()
        
        // Toolbar
        let toolBar = UIToolbar(frame: CGRectMake(0,windowHeight - toolBarHeight, windowWidth, toolBarHeight))
        toolBar.barTintColor = UIColor.customBlueColor()
        toolBar.opaque = true
        toolBar.addSubview(addButton)
        toolBar.addSubview(viewButton)
        toolBar.addSubview(settingButton)
        toolBar.addSubview(favouriteButton)
        self.view.addSubview(toolBar)
    }
    
    func initTrash() {
        let trashImage = UIHelper.resizeImage(UIImage(named: "text.png")!, newWidth: 25.0)
        let trashView = UIImageView()
        trashView.frame.size = CGSizeMake(25.0,25.0)
        trashView.center = CGPointMake(windowWidth/2.0, 80.0)
        trashView.image = trashImage
        trashView.hidden = true
        
        trashController = DragToTrash(delegate: self, trashView: trashView, alertTitle: "Delete?", alertMessage: nil, radius: 5.0)
        view.addSubview(trashView)
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
    
    func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool) {
        if let navController = self.navigationController {
            navController.pushViewController(viewControllerToPresent, animated: flag)
        } else {
            self.presentViewController(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    /*******************************************************************
     
        BUTTON ACTIONS
     
     ******************************************************************/
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
        manager.enableInteraction = true
        for vc in self.childViewControllers {
            vc.view.userInteractionEnabled = true
        }
    }
    
    func disableUserInteraction() {
        manager.enableInteraction = false
        for vc in self.childViewControllers {
            vc.view.userInteractionEnabled = false
        }
    }
    
    func cancelFavourite() {
        favouriteButton.setBackgroundImage(UIImage(named: "favourite_unselected_icon.png")!, forState: .Normal)
        favouriteButton.removeTarget(self, action: "cancelFavourite", forControlEvents: .TouchUpInside)
        favouriteButton.addTarget(self, action: "selectFavourite", forControlEvents: .TouchUpInside)
        manager.unselectFavourite()
    }
    
    func selectFavourite() {
        favouriteButton.setBackgroundImage(UIImage(named: "favourite_selected_icon.png")!, forState: .Normal)
        favouriteButton.removeTarget(self, action: "selectFavourite")
        favouriteButton.addTarget(self, action: "cancelFavourite")
        manager.selectFavourite()
    }
    
    func setting() {
        presentViewController(OtherCanvasOptionViewController(sourceView:settingButton, delegate: self), animated: true, completion: nil)
    }
    
    func cancelAddNewMoment() {
        self.dismiss(true)
    }
    
    func goToSavePage() {
        performSegueWithIdentifier("showSavePage", sender: self)
    }
    
    func loadSavePage() {
        if let navController = self.navigationController {
            navController.pushViewController(savePage!, animated: true)
        }
    }

    /*******************************************************************
     
        ADD ITEM FUNCTIONS
     
     ******************************************************************/
    func addText() {
        let newText = EditTextItemViewController(delegate: self, text: nil, textAttribute: nil)
        presentViewController(newText, animated: true)
    }
    
    private func addImage(sourceType: UIImagePickerControllerSourceType, allowsEditing: Bool) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = sourceType
        image.allowsEditing = allowsEditing
        presentViewController(image, animated: true, completion: nil)
    }
    
    func addImageFromGallery() {
        addImage(.PhotoLibrary, allowsEditing: true)
    }
    
    func addImageFromCamera() {
        addImage(.Camera, allowsEditing: false)
    }
    
    func addAudioFromRecorder(){
        let audioRecorder = AudioRecorderViewController(delegate: self)
        presentViewController(audioRecorder, animated: true)
        
        //self.performSegueWithIdentifier("newAudioRecording", sender: self)
    }

    func addAudioFromMusic() {
        
    }
    
    func addVideoFromCamera(){
        
    }
    
    func addVideoFromYoutube() {
    
    }
    
    func addSticker() {
        self.performSegueWithIdentifier("addSticker", sender: self)
    }

    /*******************************************************************
     
     LOAD FUNCTIONS
     
     ******************************************************************/
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
        controller.dismiss(true)
        addNewViewController(self.manager.addText(text, location: self.center, textAttribute: textAttribute))
    }
    
    // Functions for UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(true)
        addNewViewController(manager.addImage(image, location: self.center, editingInfo: editingInfo))
    }
    
    // Functions for MPMediaPickerControllerDelegate
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(true)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        mediaPicker.dismiss(true)
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
    
    // Functions for OtherCanvasOptionViewController
    func setCanvasBackground(controller: OtherCanvasOptionViewController) {
        let colourPickerVC: ColourPickerViewController = ColourPickerViewController(initialColour: self.view.backgroundColor, delegate: self)
        presentViewController(colourPickerVC, animated: true, completion: nil)
    }
    
    // PanGestureRecognizer
    
    func draggedView(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            view.bringSubviewToFront(trashController!.trashView)
            trashController!.trashView.hidden = false
        }
        
        if let senderView = sender.view {
            view.bringSubviewToFront(senderView)
            var translation = sender.translationInView(view)
            if senderView.frame.minY + translation.y <= 60 {
                translation.y = 60 - senderView.frame.minY
            }
            senderView.center = CGPointMake(senderView.center.x + translation.x, senderView.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: view)
            trashController!.draggedView(senderView)
        }
        
        if sender.state == .Ended {
            trashController!.trashView.hidden = true
        }
    }
    
    // DragToTrash Delegate Functions
    
    func trashItem(view:UIView) {
        view.removeFromSuperview()
    }
    
}