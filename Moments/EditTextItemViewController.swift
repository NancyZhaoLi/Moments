//
//  NewTextViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-21.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

protocol EditTextItemViewControllerDelegate {
    func addText(controller: EditTextItemViewController, textView: UITextView)
    func cancelAddTextItem(controller: EditTextItemViewController)
}

class EditTextItemView: UITextView {
    
}



class EditTextItemViewController: UIViewController {

    var delegate : EditTextItemViewControllerDelegate?
    var placeHolder: String = "Enter Your Text Here..."
    
    @IBAction func cancelAddText(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.cancelAddTextItem(self)
        }
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
