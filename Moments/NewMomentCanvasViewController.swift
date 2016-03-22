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
    var manager : NewMomentManager?
    var loadedMoment : MomentEntry?
    var addItemPopover: NewItemViewController?
    var center: CGPoint = CGPointMake(windowWidth/2.0, windowHeight/2.0)
    
    var nextButton: UIButton! = UIButton()
    
    var addButton: UIButton! = UIButton()
    var viewButton: UIButton! = UIButton()
    var settingButton: UIButton! = UIButton()
    var trashButton: UIButton! = UIButton()
    
    var canvas: UIScrollView!
    
    let addButtonImageTitle = "add_icon.png"
    let viewButtonSelectImageTitle = "view_open_icon.png"
    let viewButtonUnselectImageTitle = "view_close_icon.png"
    let trashButtonSelectImageTitle = "favourite_selected_icon.png"
    let trashButtonUnselectImageTitle = "favourite_unselected_icon.png"
    let settingButtonImageTitle = "setting_icon.png"
    
    //var trashController: DragToTrash?
    var trashButtonOn: Bool = true
    var enableInteraction: Bool = false
    
    var tapToTrashGestureRec: UITapGestureRecognizer = UITapGestureRecognizer()
    var dragItemGestureRec: UIPanGestureRecognizer = UIPanGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCanvas()
        
        if let moment = loadedMoment {
            manager = NewMomentManager(canvasVC: self, moment: moment)
            view.backgroundColor = moment.backgroundColour
        } else {
            manager = NewMomentManager(canvasVC: self)
            view.backgroundColor = UIColor.customBackgroundColor()
        }
        
        initUI()
        initGestureRec()
        
        if self.loadedMoment != nil {
            selectViewMode()
        }
    }
    
    private func initCanvas() {
        let toolBarHeight: CGFloat = 60.0
        
        canvas = UIScrollView(frame: CGRectMake(0,-60.0,windowWidth, windowHeight - toolBarHeight))
        canvas.backgroundColor = UIColor.clearColor()
        canvas.userInteractionEnabled = true
        canvas.multipleTouchEnabled = true
        canvas.showsVerticalScrollIndicator = false
        canvas.showsHorizontalScrollIndicator = false
        self.view.addSubview(canvas)
    }
    
    private func initUI() {
        let buttonSize: CGFloat = 40.0
        let toolbarItemCenters = ToolbarHelper.getCenter(30.0, totalItems: 4, inset: 20.0)
        
        addItemPopover = NewItemViewController(sourceView: self.view, delegate: self)
        
        //Navigation Buttons
        let cancelButton = NavigationHelper.leftNavButton("Cancel", target: self, action: "cancelAddNewMoment")
        nextButton = NavigationHelper.rightNavButton("Next", target: self, action: "goToSavePage")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        //Toolbar Buttons
        trashButton = UIButton(center: toolbarItemCenters[3], width: buttonSize)
        cancelTrash()
        
        addButton = ButtonHelper.imageButton(addButtonImageTitle, center: toolbarItemCenters[0], imageSize: buttonSize, target: self, action: "addItem")
        
        viewButton = UIButton(center: toolbarItemCenters[1], width: buttonSize)
        cancelViewMode()
        
        settingButton = ButtonHelper.imageButton(settingButtonImageTitle, center: toolbarItemCenters[2], imageSize: buttonSize, target: self, action: "setting")

        // Toolbar
        let toolBarHeight: CGFloat = 60.0
        let toolBar = UIToolbar(frame: CGRectMake(0,windowHeight - toolBarHeight, windowWidth, toolBarHeight))
        toolBar.barTintColor = UIColor.customBlueColor()
        toolBar.opaque = true
        toolBar.addSubview(addButton)
        toolBar.addSubview(viewButton)
        toolBar.addSubview(settingButton)
        toolBar.addSubview(trashButton)
        view.addSubview(toolBar)
    }
    
    private func initGestureRec() {
        tapToTrashGestureRec.addTarget(self, action: "tapToTrash:")
        dragItemGestureRec.addTarget(self, action: "draggedView:")
    }
    
    /*private func initTrash() {
        let trashImage = UIHelper.resizeImage(UIImage(named: "text.png")!, newWidth: 25.0)
        let trashView = UIImageView()
        trashView.frame.size = CGSizeMake(25.0,25.0)
        trashView.center = CGPointMake(windowWidth - 15.0, windowHeight/2.0)
        trashView.image = trashImage
        trashView.hidden = true
        
        trashController = DragToTrash(delegate: self, trashView: trashView, alertTitle: "Delete?", alertMessage: nil, radius: 5.0)
        view.addSubview(trashView)
    }*/
    
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
        cancelTrash()
        if let popover = self.addItemPopover {
            presentViewController(popover, animated: true, completion: nil)
        }
    }
    
    func cancelViewMode() {
        cancelTrash()
        viewButton.setImage(UIImage(named: viewButtonUnselectImageTitle)!, forState: .Normal)
        viewButton.removeTarget(self, action: "cancelViewMode", forControlEvents: .TouchUpInside)
        viewButton.addTarget(self, action: "selectViewMode", forControlEvents: .TouchUpInside)
        enableUserInteraction()
    }
    
    func selectViewMode() {
        cancelTrash()
        viewButton.setImage(UIImage(named: viewButtonSelectImageTitle)!, forState: .Normal)
        viewButton.removeTarget(self, action: "selectViewMode", forControlEvents: .TouchUpInside)
        viewButton.addTarget(self, action: "cancelViewMode", forControlEvents: .TouchUpInside)
        disableUserInteraction()
    }

    func enableUserInteraction() {
        enableInteraction = true
        for vc in self.childViewControllers {
            vc.view.userInteractionEnabled = true
        }
    }
    
    func disableUserInteraction() {
        enableInteraction = false
        for vc in self.childViewControllers {
            vc.view.userInteractionEnabled = false
        }
    }

    func setting() {
        cancelTrash()
        //presentViewController(OtherCanvasOptionViewController(sourceView:settingButton, delegate: self), animated: true, completion: nil)
        setCanvasBackground()
    }
    
    func cancelTrash() {
        if trashButtonOn {
            print ("disable trash")
            trashButton.setImage(UIImage(named: trashButtonUnselectImageTitle)!, forState: .Normal)
            trashButton.removeTarget(self, action: "cancelTrash")
            trashButton.addTarget(self, action: "selectTrash")
            trashButtonOn = false
            tapToTrashGestureRec.enabled = false
            setEnabledOfTapRecognizerOfTextItem(true)
        }
    }

    func selectTrash() {
        print("enable trash")
        trashButton.setImage(UIImage(named: trashButtonSelectImageTitle)!, forState: .Normal)
        trashButton.removeTarget(self, action: "selectTrash")
        trashButton.addTarget(self, action: "cancelTrash")
        trashButtonOn = true
        tapToTrashGestureRec.enabled = true
        setEnabledOfTapRecognizerOfTextItem(false)
    }

    func setEnabledOfTapRecognizerOfTextItem(enabled: Bool) {
        for viewController in self.childViewControllers {
            if let textItem: TextItemViewController = viewController as? TextItemViewController {
                textItem.tapRec.enabled = enabled
            }
        }
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
        self.addNewViewController(textItem)
    }
    
    func loadImage(imageItem: ImageItemViewController) {
        self.addNewViewController(imageItem)
    }
    
    func loadAudio(audioItem: AudioItemEntry) {
        
    }
    
    func loadVideo(videoItem: VideoItemEntry) {
        
    }
    
    func loadSticker(stickerItem: StickerItemEntry) {
        
    }
    
    func addNewViewController(vc: UIViewController) {
        self.canvas.addSubview(vc.view)
        initNewViewController(vc)
    }
    
    func addNewViewController(vc: UIViewController, zPosition: Int) {
        self.canvas.insertSubview(vc.view, atIndex: zPosition)
        vc.view.layer.zPosition = 0.0
        initNewViewController(vc)
    }
    
    private func initNewViewController(vc: UIViewController) {
        vc.view.addGestureRecognizer(tapToTrashGestureRec)
        vc.view.addGestureRecognizer(dragItemGestureRec)
        vc.view.multipleTouchEnabled = true
        vc.view.userInteractionEnabled = enableInteraction
        self.addChildViewController(vc)
    }
    
    /*******************************************************************
    
        DELEGATE FUNCTIONS
    
     ******************************************************************/
     
    // EditTextItemViewControllerDelegate functions
    func addText(controller: EditTextItemViewController, text: String, textAttribute: TextItemOtherAttribute) {
        controller.dismiss(true)
        addNewViewController(manager!.addText(text, location: center, textAttribute: textAttribute))
    }
    
    // Functions for UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(true)
        addNewViewController(manager!.addImage(image, location: self.center, editingInfo: editingInfo))
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
        if let audioViewController = manager!.addAudio(url, location: self.center) {
            addNewViewController(audioViewController)
        } else {
            print("cannot add recording to canvas")
        }
        
    }
    
    // Functions for OtherCanvasOptionViewController
    func setCanvasBackground(controller: OtherCanvasOptionViewController) {
        setCanvasBackground()
    }
    
    func setCanvasBackground() {
        let colourPickerVC: ColourPickerViewController = ColourPickerViewController(initialColour: view.backgroundColor, delegate: self)
        colourPickerVC.setNavigationBarTitle("Background Colour")
        presentViewController(colourPickerVC, animated: true, completion: nil)
    }
    
    // PanGestureRecognizer
    
    func draggedView(sender: UIPanGestureRecognizer) {
        /*if sender.state == .Began {
            view.bringSubviewToFront(trashController!.trashView)
            trashController!.trashView.hidden = false
        }*/
        
        if let senderView = sender.view {
            view.bringSubviewToFront(senderView)
            let translation = sender.translationInView(view)
            senderView.center = CGPointMake(senderView.center.x + translation.x, senderView.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: view)
            //trashController!.draggedView(senderView)
        }
        /*
        if sender.state == .Ended {
            trashController!.trashView.hidden = true
        }*/
    }
    
    // Tap To Trash
    
    func tapToTrash(sender: UITapGestureRecognizer) {
        if let senderView = sender.view {
            print(senderView)
            senderView.removeFromSuperview()
        }
    }
    
    
    // DragToTrash Delegate Functions
    
    /*func trashItem(view:UIView) {
        view.removeFromSuperview()
        trashController!.trashView.hidden = true
    }*/
    
}