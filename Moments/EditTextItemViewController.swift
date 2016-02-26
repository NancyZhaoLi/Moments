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
    
    func loadPlaceHolder(placeHolder: String){
        self.text = placeHolder
        self.textColor = UIColor.lightGrayColor()
    }
    
    
    func loadText(text: String?) {
        self.text = text
        self.textColor = UIColor.blackColor()
    }
    
    func setFontSize(size: CGFloat) {
        if let name = self.font?.fontName {
            self.font = UIFont(name: name, size: size)
        } else {
            self.font = UIFont(name: "Arial", size: size)
        }

    }

}



class EditTextItemViewController: UIViewController, UITextViewDelegate {

    var delegate : EditTextItemViewControllerDelegate?
    var text : String?
    var color: UIColor = UIColor.blackColor()
    let placeHolder: String = "Enter Your Text Here..."
    
    @IBOutlet weak var editTextItemView: EditTextItemView!
    
    
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
        
        self.editTextItemView.delegate = self
        self.editTextItemView.font = UIFont(name: "Helvetica", size: 25)
        if let text = self.text {
            self.editTextItemView.loadText(text)
        } else {
            self.editTextItemView.loadPlaceHolder(placeHolder)
        }
        
        print("New Text View Controller Loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            self.editTextItemView.loadText(nil)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            self.editTextItemView.loadPlaceHolder(placeHolder)
        }
    }
    

}
