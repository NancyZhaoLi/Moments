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

class NewViewController: UIViewController,UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NewCompViewControllerDelegate, NewTextViewControllerDelegate, MPMediaPickerControllerDelegate {
    
    var touchLocation: CGPoint?
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print("Image Selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let frame = CGRectMake(self.touchLocation!.x,self.touchLocation!.y,80,80)
        let imageView = ImageItemViewController(frame: frame)
        imageView.image = image
        self.view.addSubview(imageView)
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print("Video or audio selected")
        if let mediaItem: MPMediaItem = mediaItemCollection.representativeItem {
            if mediaItem.mediaType == .AnyVideo {
                
            } else if mediaItem.mediaType == .AnyAudio {
                //let video = AVPlayerViewController()
            }
        }
    }

    
    @IBAction func save(sender: AnyObject) {
        //save all view items for backup
    }
    
    @IBAction func addItem(sender: AnyObject) {
        if sender.title == "Text" {
            let myTextView: UITextView = UITextView(frame: CGRect(x: 100, y: 200, width: 100.00, height: 60.00));
            myTextView.text = "..."
            myTextView.editable = true
            myTextView.layer.borderWidth = 2
            myTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.view.addSubview(myTextView)
        }
        else if sender.title == "Image" {
            let frame = CGRectMake(100,100,50,50)
            let imageView = ImageItemViewController(frame: frame)
            imageView.image = UIImage(named: "album")
            self.view.addSubview(imageView)
        }
        else if sender.title == "Video" {
            
        }
        else if sender.title == "Audio" {
            
        }
    }
    
    func addItem(controller: NewCompViewController, type: String? ){
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        if let typeToAdd = type {
            if typeToAdd == "text" {
                self.performSegueWithIdentifier("showNewTextModal", sender: self)
            } else if typeToAdd == "image" {
                addImage()
            } else if typeToAdd == "audio" {
                addAudio()
            } else if typeToAdd == "video" {
                addVideo()
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
    }
    
    func addImage(){
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
        
        // Do any additional setup after loading the view.
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
            self.performSegueWithIdentifier("showNewCompPopover", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showNewCompPopover" {
            let vc = segue.destinationViewController as! NewCompViewController
            vc.touchLocation = self.touchLocation
            vc.delegate = self

            let popoverVC = vc.popoverPresentationController
            popoverVC?.delegate = self
            popoverVC?.sourceRect = CGRectMake(self.touchLocation!.x, self.touchLocation!.y, 0, 0)
        } else if segue.identifier == "showNewTextModal" {
            let vc = segue.destinationViewController as! NewTextViewController
            vc.modalPresentationStyle = .OverCurrentContext
            vc.delegate = self
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
}