//
//  NewCompViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-21.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class NewCompViewController: UIViewController {
    
    var touchLocation : CGPoint?
    var sender: NewViewController?
    
    @IBAction func newTextPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sender!.addText()
    }
    
    @IBAction func newImagePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sender!.addImage()
    }
    
    @IBAction func newAudioPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sender!.addAudio()
    }
    
    @IBAction func newVideoPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sender!.addVideo()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("menu popup loaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
