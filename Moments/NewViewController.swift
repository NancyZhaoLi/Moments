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

class NewViewController: UIViewController,UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NewTextViewControllerDelegate, MPMediaPickerControllerDelegate {
    
    var touchLocation: CGPoint?
    var touchMode : String? = "View"
    @IBOutlet weak var momentTitle: UITextField!
    
    @IBAction func selectTouchMode(sender: AnyObject) {
        print ("button selected")
        if let title = sender.currentTitle {
            touchMode = title
            print ("mode selected" + String(touchMode))
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        
    }
    
    func resetView (){
        touchMode = "View"
    }
    
    // Functions for UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print("Image Selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let frame = CGRectMake(self.touchLocation!.x,self.touchLocation!.y,200,200)
        let imageView = ImageItemViewController(frame: frame)
        imageView.image = image
        self.view.addSubview(imageView)
        resetView()
    }
    
    // Functions for MPMediaPickerControllerDelegate
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        resetView()
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
        resetView()
    }
    
    func cancelAddItem(controller: NewTextViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        resetView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("New moment loaded")

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
            if let touchMode = self.touchMode {
                if  touchMode == "Text" {
                    self.performSegueWithIdentifier("showNewTextModal", sender: self)
                } else if touchMode == "Image" {
                    addImage()
                } else if touchMode == "Audio" {
                    addAudio()
                } else if touchMode == "Video" {
                    addVideo()
                } else if touchMode == "Sticker" {
                    
                } else {
                    
                }
            }
            //self.performSegueWithIdentifier("showNewCompPopover", sender: self)
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
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
}