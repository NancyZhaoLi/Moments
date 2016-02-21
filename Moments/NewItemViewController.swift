//
//  NewCompViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-21.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

protocol NewItemViewControllerDelegate {
    func addItem(controller: NewItemViewController, type: String? )
}


class NewItemViewController: UIViewController {
    
    var delegate: NewItemViewControllerDelegate?
    
    @IBAction func newTextPressed(sender: AnyObject) {
        if let delegate = self.delegate {
            print("add text")
            delegate.addItem(self, type: "text")
        }
    }
    
    @IBAction func newImagePressed(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.addItem(self, type: "image")
        }
    }
    
    @IBAction func newAudioPressed(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.addItem(self, type: "audio")
        }
    }
    
    @IBAction func newVideoPressed(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.addItem(self, type: "video")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("menu popup loaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}