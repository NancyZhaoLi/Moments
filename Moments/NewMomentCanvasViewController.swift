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
import MobileCoreServices
import Photos

/*protocol NewMomentItemGestureDelegate {
    /*func addTrashGR(trashGR: UITapGestureRecognizer)
    func addDragGR(dragGR: UIPanGestureRecognizer)
    func addPinchGR(pinchGR: UIPinchGestureRecognizer)
    func addRotateGR(rotateGR: UIRotationGestureRecognizer)
    */
    func addTrashGR()
    func addDragGR()
    func addPinchGR()
    func addRotateGR()
    func enableTrash(enabled: Bool)
    func enableViewMode(enabled: Bool)
    func tapToTrash(sender: UITapGestureRecognizer)
}*/

class NewMomentCanvasViewController: UIViewController,
    UIPopoverPresentationControllerDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    EditTextItemViewControllerDelegate,
    MPMediaPickerControllerDelegate,
    ColourPickerViewControllerDelegate,
    AudioRecorderViewControllerDelegate,
    NewItemViewControllerDelegate,
    StickerPickerControllerDelegate {
    
    var savePage : NewMomentSavePageViewController?
    var manager : NewMomentManager?
    var loadedMoment : Moment?
    private var addItemPopover: NewItemViewController?
    private let center: CGPoint = CGPointMake(windowWidth/2.0, windowHeight/2.0)
    
    let addButtonImageTitle = "add_icon.png"
    let viewButtonSelectImageTitle = "locked_icon.png"
    let viewButtonUnselectImageTitle = "unlocked_icon.png"
    let trashButtonSelectImageTitle = "trash_selected_icon.png"
    let trashButtonUnselectImageTitle = "trash_icon.png"
    let settingButtonImageTitle = "bucket_icon.png"
    
    // Button to go to savePage
    private var nextButton: UIButton! = UIButton()
    
    // Toolbar Icons
    private var addButton: UIButton! = UIButton()
    private var viewButton: UIButton! = UIButton()
    private var settingButton: UIButton! = UIButton()
    private var trashButton: UIButton! = UIButton()
    
    var canvas: UIScrollView!
    private var trashButtonOn: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        initCanvas()
        
        if let moment = loadedMoment {
            manager = NewMomentManager(canvasVC: self, moment: moment)
            view.backgroundColor = moment.getBackgroundColour()
        } else {
            manager = NewMomentManager(canvasVC: self)
            view.backgroundColor = UIColor.customBackgroundColor()
        }
        initUI()
        if self.loadedMoment != nil {
            selectViewMode()
        }
    }
    
    private func initCanvas() {
        let toolBarHeight: CGFloat = 60.0
        
        canvas = UIScrollView(frame: CGRectMake(0,0,windowWidth, windowHeight - toolBarHeight))
        canvas.backgroundColor = UIColor.clearColor()
        canvas.userInteractionEnabled = true
        canvas.multipleTouchEnabled = true
        canvas.showsVerticalScrollIndicator = false
        canvas.showsHorizontalScrollIndicator = false
        self.view.addSubview(canvas)
    }
    
    private func initUI() {
        addItemPopover = NewItemViewController(sourceView: self.view, delegate: self)
        
        initNavigatinButtons()
        
        let toolBar = initToolbar()
        view.addSubview(toolBar)
    }
    
    private func initNavigatinButtons() {
        //Navigation Buttons
        let cancelButton = NavigationHelper.leftNavButton("Cancel", target: self, action: "cancelAddNewMoment")
        nextButton = NavigationHelper.rightNavButton("Next", target: self, action: "goToSavePage")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
    }
    
    private func initToolbar() -> UIToolbar {
        let toolbarItemCenters = ToolbarHelper.getCenter(30.0, totalItems: 4, inset: 20.0)
        let buttonSize: CGFloat = 40.0

        // Toolbar buttons
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
        
        return toolBar
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addText" {
            let vc = segue.destinationViewController as! EditTextItemViewController
            vc.delegate = self
        } else if segue.identifier == "addSticker" {
            let vc = segue.destinationViewController as! StickerViewController
            vc.delegate = self
        } else if segue.identifier == "showSavePage" {
            if let savePage = segue.destinationViewController as? NewMomentSavePageViewController {
                savePage.canvas = self
                savePage.manager = self.manager
                if let navController = self.navigationController as? NewMomentNavigationController {
                    if let delegate = navController.newMomentDelegate {
                        savePage.delegate = delegate
                    }
                }
                nextButton.removeTarget(self, action: "goToSavePage", forControlEvents: .TouchUpInside)
                nextButton.addTarget(self, action: "loadSavePage", forControlEvents: .TouchUpInside)
                self.savePage = savePage
            }
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
     
        ADD BUTTON FUNCTIONS
     
     ******************************************************************/
    func addItem() {
        cancelTrash()
        if let popover = self.addItemPopover {
            presentViewController(popover, animated: true, completion: nil)
        }
    }
    
    func cancelAddNewMoment() {
        self.dismiss(true)
    }
    
    /*******************************************************************
     
     ADD ITEM FUNCTIONS
     
     ******************************************************************/
    func addText() {
        let newText = EditTextItemViewController(delegate: self, text: nil, textAttribute: nil)
        presentViewController(newText, animated: true)
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
    }
    
    func addAudioFromMusic() {
        let musicPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
        musicPicker.delegate = self
        musicPicker.allowsPickingMultipleItems = false
        musicPicker.showsCloudItems = false
        
        presentViewController(musicPicker, animated: true, completion: nil)
    }
    
    func addSticker() {
        self.performSegueWithIdentifier("addSticker", sender: self)
    }
    
    func addVideoFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let video = UIImagePickerController()
            video.delegate = self
            video.sourceType = .Camera
            //video.cameraCaptureMode = .Video
            video.mediaTypes = [kUTTypeMovie as String]
            
            presentViewController(video, animated: true, completion: nil)
        } else {
            print("camera not available for video")
        }
    }
    
    func addVideoFromYoutube() {
        
    }
    
    private func addImage(var sourceType: UIImagePickerControllerSourceType, allowsEditing: Bool) {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            sourceType = .PhotoLibrary
        }
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = sourceType
        image.allowsEditing = allowsEditing
        image.mediaTypes = [kUTTypeImage as String]
        if sourceType == .Camera {
            /*let overlay = CameraOverlayViewController(frame: self.view.frame)
            overlay.cameraPicker = image
            overlay.initDelegate(self)
            image.cameraOverlayView = overlay.view
            image.addChildViewController(overlay)*/
        }
        presentViewController(image, animated: true, completion: nil)
    }
    
    
    /*func addNewViewController(vc: UIViewController) {
        self.canvas.addSubview(vc.view)
        initNewViewController(vc)
    }
    
    func addNewViewController(vc: UIViewController, zPosition: Int) {
        self.canvas.insertSubview(vc.view, atIndex: zPosition)
        vc.view.layer.zPosition = 0.0
        initNewViewController(vc)
    }
    
    private func initNewViewController(vc: UIViewController) {
        
        if let delegate = vc as? NewMomentItemGestureDelegate {
            delegate.addTrashGR(trashGR(vc))
            delegate.addDragGR(dragItemGR())
        }
        
        if let textItemVC = vc as? TextItemViewController {
            let textItemVC = textItemVC as NewMomentItemGestureDelegate
            textItemVC.addPinchGR(pinchTextItemGR())
            textItemVC.addRotateGR(rotateGR())
        } else if let vc = vc as? NewMomentItemGestureDelegate {
            vc.addPinchGR(pinchItemGR())
            vc.addRotateGR(rotateGR())
        }
        
        vc.view.multipleTouchEnabled = true
        vc.view.userInteractionEnabled = true
        self.addChildViewController(vc)
    }*/


    /*******************************************************************
     
     VIEW BUTTON FUNCTIONS
     
     ******************************************************************/
    
    func cancelViewMode() {
        cancelTrash()
        viewButton.setImage(UIImage(named: viewButtonUnselectImageTitle)!, forState: .Normal)
        viewButton.removeTarget(self, action: "cancelViewMode", forControlEvents: .TouchUpInside)
        viewButton.addTarget(self, action: "selectViewMode", forControlEvents: .TouchUpInside)
        
        manager!.cancelViewMode()
    }
    
    func selectViewMode() {
        cancelTrash()
        viewButton.setImage(UIImage(named: viewButtonSelectImageTitle)!, forState: .Normal)
        viewButton.removeTarget(self, action: "selectViewMode", forControlEvents: .TouchUpInside)
        viewButton.addTarget(self, action: "cancelViewMode", forControlEvents: .TouchUpInside)
        
        manager!.selectViewMode()
    }

    /*******************************************************************
     
     SETTING BUTTON FUNCTIONS
     
     ******************************************************************/

    func setting() {
        cancelTrash()
        //presentViewController(OtherCanvasOptionViewController(sourceView:settingButton, delegate: self), animated: true, completion: nil)
        setCanvasBackground()
    }


    /*******************************************************************
     
     TRASH BUTTON FUNCTIONS
     
     ******************************************************************/
    func cancelTrash() {
        if trashButtonOn {
            trashButton.setImage(UIImage(named: trashButtonUnselectImageTitle)!, forState: .Normal)
            trashButton.removeTarget(self, action: "cancelTrash")
            trashButton.addTarget(self, action: "selectTrash")
            trashButtonOn = false
            
            manager!.setEnabledOfTapToTrashGR(false)
        }
    }

    func selectTrash() {
        trashButton.setImage(UIImage(named: trashButtonSelectImageTitle)!, forState: .Normal)
        trashButton.removeTarget(self, action: "selectTrash")
        trashButton.addTarget(self, action: "cancelTrash")
        trashButtonOn = true
        
        manager!.setEnabledOfTapToTrashGR(true)
    }
    

    
    /*******************************************************************
     
     OTHER SEGUE FUNCTIONS
     
     ******************************************************************/
    
    func goToSavePage() {
        performSegueWithIdentifier("showSavePage", sender: self)
    }
    
    func loadSavePage() {
        if let navController = self.navigationController {
            navController.pushViewController(savePage!, animated: true)
        }
    }

    /*******************************************************************
    
        DELEGATE FUNCTIONS
    
     ******************************************************************/
     
    // EditTextItemViewControllerDelegate functions
    func addText(controller: EditTextItemViewController, text: String, textAttribute: TextItemOtherAttribute) {
        controller.dismiss(true)
        manager!.addText(text, location: center, textAttribute: textAttribute)
    }
    
    // Functions for UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismiss(true)
        
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]

        if let type:AnyObject = mediaType {
            if type is String {
                let stringType = type as! String
                if stringType == kUTTypeMovie as String {
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                    if let url = urlOfVideo {
                        manager!.addRecordedVideo(fileURL: url, location: self.center)
                        /*    addNewViewController(videoViewController)
                        } else {
                            print("cannot add videoItemVC onto canvas")
                        }*/
                    } else {
                        print("no url for video")
                    }
                } else {
                    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                        manager!.addImage(image, location: self.center)
                    } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                        manager!.addImage(image, location: self.center)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismiss(true)
    }
    
    // Functions for MPMediaPickerControllerDelegate
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(true)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        mediaPicker.dismiss(true)
        if let music: MPMediaItem = mediaItemCollection.representativeItem {
            manager!.addMusicAudio(music, location: self.center)
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
    
    // Functions for AudioRecorderViewController Delegate
    func saveRecording(controller: AudioRecorderViewController, url: NSURL) {
        manager!.addRecordedAudio(fileURL: url, location: self.center)

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
    
    // Functions for StickerPickerController Delegate
    func didPickSticker(stickerPicker: StickerViewController, stickerName: String) {
        stickerPicker.dismiss(true)
        manager!.addSticker(stickerName, location: self.center)
    }
    
    
    /*********************************************************************************
     
     GESTURE RECOGNIZERS
     
     *********************************************************************************/


    
    // PinchGestureRecognizer
    func pinchedView(sender: UIPinchGestureRecognizer) {
        if let senderView = sender.view {
            canvas.bringSubviewToFront(senderView)
            switch sender.state {
            
            case UIGestureRecognizerState.Began:
                if sender.numberOfTouches() != 2 {
                    return
                }
                showBorder(senderView)
                break
            
            case UIGestureRecognizerState.Changed:
                if sender.numberOfTouches() != 2 {
                    return
                }
                senderView.transform  = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
                sender.scale = 1.0
                break
            
            default:
                hideBorder(senderView)
                break

            }
        }
    }
    
    func pinchedTextView(sender: UIPinchGestureRecognizer) {
        if let senderView = sender.view as? TextItemView {
            canvas.bringSubviewToFront(senderView)
            switch sender.state {
                
            case UIGestureRecognizerState.Began:
                if sender.numberOfTouches() != 2 {
                    return
                }
                showBorder(senderView)
                for var i = 0; i < sender.numberOfTouches(); i++ {
                    senderView.beginPinchCoor.append(sender.locationOfTouch(i, inView: self.canvas))
                }
                break
                
            case UIGestureRecognizerState.Changed:
                if sender.numberOfTouches() != 2 {
                    return
                }
                var newCoor = [CGPoint]()
                for var i = 0; i < sender.numberOfTouches(); i++ {
                    newCoor.append(sender.locationOfTouch(i, inView: self.canvas))
                }
                
                let horizontalScale: CGFloat = horizontalDistance(newCoor) / horizontalDistance(senderView.beginPinchCoor)
                var verticalScale: CGFloat = verticalDistance(newCoor) / verticalDistance(senderView.beginPinchCoor)
                if verticalScale > 1.3 || verticalScale < 0.8 {
                    return
                } else if verticalScale > 1.0 {
                    verticalScale = 1.0 + (verticalScale - 1.0) * 0.2
                } else if verticalScale < 1.0 {
                    verticalScale = 1.0 - (1.0 - verticalScale) * 0.2
                }
                
                /*print("new coordinate: \(newCoor)")
                print("vertial distance of new coordinate: \(verticalDistance(newCoor))")
                print("old coordinate: \(senderView.beginPinchCoor)")
                print("vertical distance of old coordinate: \(verticalDistance(senderView.beginPinchCoor))")
                print(verticalScale)*/

                let previousCenter: CGPoint = senderView.center
                let newWidth = senderView.frame.width * horizontalScale
                let newHeight = senderView.frame.height * verticalScale
                let changeInWidth: CGFloat = newWidth - senderView.frame.width
                let changeInHeight: CGFloat = newHeight - senderView.frame.height
                
                if newWidth < UIHelper.textSize("A", font: senderView.font!).width + 20.0 ||
                    newHeight < UIHelper.textSize("A", font: senderView.font!).height + 20.0{
                    return
                }
                
                senderView.frame = CGRectMake(senderView.frame.origin.x, senderView.frame.origin.y, senderView.frame.width + changeInWidth, senderView.frame.height + changeInHeight)
                senderView.center = CGPointMake(previousCenter.x + changeInWidth/2.0, previousCenter.y + changeInHeight/2.0)

                senderView.beginPinchCoor = newCoor
                sender.scale = 1.0
                break
                
            default:
                senderView.beginPinchCoor.removeAll()
                hideBorder(senderView)
                break
            }
        }
    }

    
    // PanGestureRecognizer
    func draggedView(sender: UIPanGestureRecognizer) {
        print("drag")
        if let senderView = sender.view {
            canvas.bringSubviewToFront(senderView)
            switch sender.state {
                
            case UIGestureRecognizerState.Began:
                if sender.numberOfTouches() != 1 {
                    return
                }
                showBorder(senderView)
                break
                
            case UIGestureRecognizerState.Changed:
                if sender.numberOfTouches() != 1 {
                    return
                }
                let translation = sender.translationInView(view)
                senderView.center = CGPointMake(senderView.center.x + translation.x, senderView.center.y + translation.y)
                sender.setTranslation(CGPointZero, inView: view)
                break
                
            default:
                hideBorder(senderView)
                break
            
            }
        }
    }
    
    // UIRotationGestureRecognizer
    func rotateView(sender: UIRotationGestureRecognizer) {
        if let senderView = sender.view {
            var lastRotation = CGFloat()
            canvas.bringSubviewToFront(senderView)
            if (sender.state == UIGestureRecognizerState.Ended) {
                lastRotation = 0.0
            }
            
            let rotation = 0.0 - (lastRotation - sender.rotation)
            let currentTransform = senderView.transform
            let newTransform = CGAffineTransformRotate(currentTransform, rotation)
            senderView.transform = newTransform
            
            if let textView = senderView as? TextItemView {
                textView.rotation += sender.rotation
            } else if let imageView = senderView as? ImageItemView {
                imageView.rotation += sender.rotation
                print("image rotation changed: \(imageView.rotation)")
            }
            
            sender.rotation = 0.0
        }
    }
    
    // Gesture Recognizers' Helper Functions
    private func verticalDistance(coordinates: [CGPoint]) -> CGFloat {
        return fabs(coordinates[0].y - coordinates[1].y)
    }
    
    private func horizontalDistance(coordinates: [CGPoint]) -> CGFloat {
        return fabs(coordinates[0].x - coordinates[1].x)
    }
    
    
    private func showBorder(view: UIView) {
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
        view.layer.borderWidth = 1.0
    }
    
    private func hideBorder(view: UIView) {
        view.layer.borderColor = nil
        view.layer.borderWidth = 0.0
    }
    
}