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

/* To dos
1. Change initial textViewBackgroundColour


*/


class EditTextItemViewController: UIViewController, UITextViewDelegate, UINavigationBarDelegate,  TextSettingViewControllerDelegate {
    
    var delegate : EditTextItemViewControllerDelegate?
    internal var text : String {
        get {
            return self.text
        }
        set(text) {
            self.text = text
        }
    }
    internal var textColour: UIColor {
        get {
            return self.textColour
        }
        set(colour) {
            self.textColour = colour
            // If colour is too light, change the background colour
        }
    }
    internal var textFont: UIFont {
        get {
            return self.textFont
        }
        set(textFont) {
            self.textFont = textFont
        }
    }
    internal var textAlignment: NSTextAlignment {
        get {
            return self.textAlignment
        }
        set(textAlignment) {
            self.textAlignment = textAlignment
        }
    }

    internal var textViewBackgroundColour: UIColor {
        get {
            return self.textViewBackgroundColour
        }
        set(backgroundColour) {
            self.textViewBackgroundColour = backgroundColour
        }
    }
    internal static let placeHolder: String = "Enter Your Text Here..."
    
    @IBOutlet weak var editTextItemView: EditTextItemView!
    
    convenience init() {
        self.init(initialText: EditTextItemViewController.placeHolder)
    }
    
    init(initialText: String) {
        super.init(nibName: nil, bundle: nil)
        self.text = initialText
        self.textColour = UIColor.blackColor()
        self.textAlignment = .Left
        self.textFont = UIFont(name: "Helvetical Neue", size: 30)!
        self.textViewBackgroundColour = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("New Text View Controller Loaded")
    }
    
    
    @IBAction func cancelAddText(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.cancelAddTextItem(self)
        }
    }
    
    
    @IBAction func addText(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.addText(self, textView: editTextItemView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTextSettings" {
            let settingVC = segue.destinationViewController as! TextSettingViewController
            settingVC.delegate = self
        }
    }
    
    // Function for placeholder text
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            self.editTextItemView.loadText(nil)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            self.editTextItemView.loadPlaceHolder(EditTextItemViewController.placeHolder)
        }
    }
    
    // TextSettingViewController delegate
    
    func changeTextItemSetting(controller: TextSettingViewController) {
        editTextItemView.textColor = controller.getTextColour()
        let newFont =
        editTextItemView.font = newFont
    }
    
    
}

