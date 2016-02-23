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


func debug(msg: String) {
    let debug = true
    
    if (debug) {
        print(msg)
    }
}


class NewMomentViewController: UIViewController,UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NewTextViewControllerDelegate, MPMediaPickerControllerDelegate {
    
    var touchLocation: CGPoint?
    var touchMode : String = "View"
    var favourite : Bool = false
    var savePageAccessed : Bool = false
    var savePageViewController : NewMomentSecondViewController?
    
    @IBOutlet weak var addItemBar: UIToolbar!
    
    @IBAction func goToSavePage(sender: AnyObject) {
        if (savePageAccessed) {
            print("presentView")
            presentViewController(self.savePageViewController!, animated: true, completion: nil)
        } else {
            print("performSegue")
            performSegueWithIdentifier("newMomentToSavePageSegue", sender: self)
        }
    }
    
    @IBAction func addItem(sender: AnyObject) {
        debug("[addItem] - + Item Button Pressed")
        if (addItemBar.hidden) {
            displayAddItemBar()
        } else {
            hideAddItemBar()
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
    
    @IBAction func selectTouchMode(sender: AnyObject) {
        debug("[selectTouchMode] - one of the add type selected")
        if let title = sender.currentTitle {
            self.touchMode = title!
            debug("[selectTouchMode] - mode selected: " + String(self.touchMode))
            if (title == "View" && !(addItemBar.hidden)) {
                hideAddItemBar()
            }
        }
    }
    
    func resetTouchMode(){
        self.touchMode = "View"
    }
    
    @IBAction func otherOptions(sender:AnyObject) {
        debug("[otherOptions] - other Button pressed")
        self.performSegueWithIdentifier("otherOptionPopover", sender: self)
    }
    
    @IBOutlet weak var favouriteSetter: UIButton!
    
    @IBAction func setFav(sender: AnyObject) {
        debug("[otherOptions] - favourite Button pressed")
        self.favourite = !(self.favourite)
    }
    
    @IBAction func nextStep(sender: AnyObject) {
        debug("[nextStep] - next Button pressed")
        //self.performSegueWithIdentifier("nextStepModal", sender: self)
    }
    
    
    // Functions for UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print("Image Selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let frame = CGRectMake(self.touchLocation!.x,self.touchLocation!.y,200,200)
        let imageView = ImageItemViewController(frame: frame)
        imageView.image = image
        self.view.addSubview(imageView)
    }
    
    // Functions for MPMediaPickerControllerDelegate
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("Video or audio selected")
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        if let mediaItem: MPMediaItem = mediaItemCollection.representativeItem {
            if mediaItem.mediaType == .AnyAudio {
                if let url = mediaItem.assetURL {
                    do {
                        let player = try AVAudioPlayer(contentsOfURL: url)
                        if let playerViewController = storyboard?.instantiateViewControllerWithIdentifier("audioPlayer") as? AudioPlayerViewController {
                            playerViewController.player = player
                            
                            self.view.addSubview(playerViewController.view)
                            self.addChildViewController(playerViewController)
                        }
                    } catch {
                        print("audio player cannot be created")
                    }

                }
            } else if mediaItem.mediaType == .AnyVideo {
                if let url = mediaItem.assetURL {
                    let player = AVPlayer(URL: url)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                
                    playerViewController.view.frame = CGRectMake(self.touchLocation!.x, self.touchLocation!.y, 100, 80)
                    self.view.addSubview(playerViewController.view)
                    self.addChildViewController(playerViewController)
                }
            }
        }
    }

    
    func addText(controller: NewTextViewController, textView: UITextView) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        let tv = UITextView(frame: CGRectMake(self.touchLocation!.x, self.touchLocation!.y, 120, 120))
        tv.textAlignment = textView.textAlignment
        tv.textColor = textView.textColor
        tv.backgroundColor = textView.backgroundColor
        tv.text = textView.text
        self.view.addSubview(tv)
        resetTouchMode()
    }
    
    func cancelAddItem(controller: NewTextViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addImage(){
        print("add image")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //To get to camera
        //image.sourceType = UIImagePickerControllerSourceType.Camera
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        resetTouchMode()
    }
    
    func addAudio(){
        let audio = MPMediaPickerController(mediaTypes: .AnyAudio)
        audio.delegate = self
        audio.allowsPickingMultipleItems = false
        self.presentViewController(audio, animated: true, completion: nil)
        resetTouchMode()
    }
    
    func addVideo(){
        let video = MPMediaPickerController(mediaTypes: .AnyVideo)
        video.delegate = self
        video.allowsPickingMultipleItems = false
        self.presentViewController(video, animated: true, completion: nil)
        resetTouchMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("New moment loaded")
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touches.isEmpty) {
            print("empty")
        } else {
            let touch = touches.first!
            self.touchLocation = touch.locationInView(touch.view)
                if  self.touchMode == "Text" {
                    self.performSegueWithIdentifier("showNewTextModal", sender: self)
                } else if self.touchMode == "Image" {
                    addImage()
                } else if self.touchMode == "Audio" {
                    addAudio()
                } else if self.touchMode == "Video" {
                    addVideo()
                } else if self.touchMode == "Sticker" {
                    
                } else {
                    
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if segue.identifier == "showNewCompPopover" {
            //let vc = segue.destinationViewController as! NewItemViewController
            //vc.delegate = self

            //let popoverVC = vc.popoverPresentationController
            //popoverVC?.delegate = self
            //popoverVC?.sourceRect = CGRectMake(self.touchLocation!.x, self.touchLocation!.y, 0, 0)
        //}
        if segue.identifier == "showNewTextModal" {
            let vc = segue.destinationViewController as! NewTextViewController
            vc.modalPresentationStyle = .OverCurrentContext
            vc.delegate = self
        } else if segue.identifier == "newMomentToSavePageSegue" {
            savePageAccessed = true
            self.savePageViewController = segue.destinationViewController as! NewMomentSecondViewController
            self.savePageViewController!.delegate = self
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func backFromSecondView() {
        self.savePageViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
}