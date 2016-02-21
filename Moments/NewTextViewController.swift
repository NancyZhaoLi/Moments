//
//  NewTextViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-21.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

protocol NewTextViewControllerDelegate {
    func addText(controller: NewTextViewController, textView: UITextView)
}


class NewTextViewController: UIViewController {

    var delegate : NewTextViewControllerDelegate?
    
    @IBAction func cancelAddText(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func addText(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.addText(self, textView: textEditView)
        }
        
    }
    
    @IBOutlet weak var textEditView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("New Text View Controller Loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
