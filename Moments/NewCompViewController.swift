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
        let textView = UITextView(frame: CGRectMake(self.touchLocation!.x, self.touchLocation!.y, 120, 120))
        textView.textAlignment = NSTextAlignment.Left
        textView.textColor = UIColor.whiteColor()
        textView.backgroundColor = UIColor.brownColor()
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sender!.view.addSubview(textView)
    }
    
    @IBAction func newImagePressed(sender: AnyObject) {
    }
    
    @IBAction func newAudioPressed(sender: AnyObject) {
    }
    
    @IBAction func newVideoPressed(sender: AnyObject) {
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
