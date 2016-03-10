//
//  NewTextViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-21.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

protocol EditTextItemViewControllerDelegate {
    func addText(controller: EditTextItemViewController, text: String, textColour: UIColor, textFont: UIFont, textAlignment: NSTextAlignment)
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
    
}

/* To dos
1. Change initial textViewBackgroundColour


*/


class EditTextItemViewController: UIViewController, UITextViewDelegate, UINavigationBarDelegate,  TextSettingViewControllerDelegate {
    
    var delegate: EditTextItemViewControllerDelegate?
    var text: String = EditTextItemViewController.placeHolder
    var textColour: UIColor = UIColor.blackColor()
    var textFont: UIFont = UIFont(name: "Helvetica Neue", size: 30)!
    var textAlignment: NSTextAlignment = .Left
    var textViewBackgroundColour: UIColor = UIColor.whiteColor()

    private static let placeHolder: String = "Enter Your Text Here..."
    
    @IBOutlet weak var editTextItemView: EditTextItemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("New Text View Controller Loaded")
        
        if self.text == EditTextItemViewController.placeHolder {
            editTextItemView.loadPlaceHolder(self.text)
        } else {
            editTextItemView.loadText(self.text)
        }
        
        editTextItemView.textAlignment = self.textAlignment
        editTextItemView.font = self.textFont
        editTextItemView.backgroundColor = self.textViewBackgroundColour
        editTextItemView.delegate = self
    }
    
    @IBAction func cancelAddText(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.cancelAddTextItem(self)
        }
    }
    
    @IBAction func addText(sender: AnyObject) {
        if let delegate = self.delegate {
            self.text = self.editTextItemView.text
            if self.text == EditTextItemViewController.placeHolder {
                self.text = "You didn't write anything..."
            }
            delegate.addText(self, text: self.text,
                textColour: self.textColour, textFont: self.textFont,
                textAlignment: self.textAlignment)
        }
    }
    
    @IBAction func unwindToEditText(sender: UIStoryboardSegue) {
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTextSetting" {
            let textSettingVC = segue.destinationViewController as! TextSettingViewController
            textSettingVC.delegate = self
        }
    }
    
    // Functions for TextSettingViewController Delegate
    func changeTextColour(colour: UIColor) {
        self.textColour = colour
        if editTextItemView.text != EditTextItemViewController.placeHolder {
            editTextItemView.textColor = colour
        }
    }
    
    func changeTextFont(font: UIFont) {
        self.textFont = font
        editTextItemView.font = font
    }
    
    func changeTextAlignment(alignment: NSTextAlignment) {
        self.textAlignment = alignment
        editTextItemView.textAlignment = alignment
    }
    
    // Function for placeholder text
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == EditTextItemViewController.placeHolder{
            self.editTextItemView.text = nil
            textView.textColor = self.textColour
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            self.editTextItemView.loadPlaceHolder(EditTextItemViewController.placeHolder)
        }
    }

}

