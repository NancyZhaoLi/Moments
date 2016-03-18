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
    
    /*******************************************************************
     
        IBOUTLET AND IBACTION
     
     ******************************************************************/
    
    @IBOutlet weak var favouriteSetter: UIButton!
    var nextButton: UIButton! = UIButton()
    
    @IBAction func cancelAddNewMoment(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.removeFromParentViewController()
    }
    
    @IBAction func addItem(sender: AnyObject) {
        if let popover = self.addItemPopover {
            presentViewController(popover, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectTouchMode(sender: AnyObject) {
        enableUserInteraction()
    }
    
    @IBAction func setFav(sender: AnyObject) {
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
    
    
    @IBOutlet weak var otherOptions: UIButton!
    
    @IBAction func otherOptions(sender: AnyObject) {
        presentViewController(OtherCanvasOptionViewController(sourceView:self.otherOptions, delegate: self), animated: true, completion: nil)
    }
    
    /*******************************************************************
     
        OVERRIDDEN UIVIEWCONTROLLER FUNCTIONS
     
     ******************************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(246/255.0), alpha: 1.0)
        
        if let moment = self.loadedMoment {
            manager.loadCanvas(self, moment: moment)
        } else {
            manager.setCanvas(self)
        }
        self.addItemPopover = NewItemViewController(sourceView: self.view, delegate: self)
        
        nextButton = UIButton(frame: CGRectMake(windowWidth - 58,3,55,37))
        nextButton.addTarget(self, action: "goToSavePage", forControlEvents: .TouchUpInside)
        nextButton.setTitle("Next", forState: .Normal)
        nextButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
    }
    
    func goToSavePage() {
        performSegueWithIdentifier("newMomentToSavePageSegue", sender: self)
    }
    
    func loadSavePage() {
        if let navController = self.navigationController {
            navController.pushViewController(savePage!, animated: true)
            print("push view")
        } else {
            print("no navController")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addText" {
            let vc = segue.destinationViewController as! EditTextItemNavigationController
            vc.modalPresentationStyle = .OverCurrentContext
            vc.viewDelegate = self
        } else if segue.identifier == "addSticker" {
            
        } else if segue.identifier == "newMomentToSavePageSegue" {
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
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func addImage(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func addAudio(){
        let audioRecorder = AudioRecorderViewController(sourceView: self.view, delegate: self)
        
        self.performSegueWithIdentifier("newAudioRecording", sender: self)
    }
    
    func addVideo(){
        let video = MPMediaPickerController(mediaTypes: .AnyVideo)
        video.delegate = self
        video.allowsPickingMultipleItems = false
        self.presentViewController(video, animated: true, completion: nil)
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