//
//  NewTextViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-21.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

protocol EditTextItemViewControllerDelegate {
    func addText(controller: EditTextItemViewController, text: String, textAttribute: TextItemOtherAttribute)
}

class EditTextItemView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.textColor = UIColor.blackColor()
        self.textAlignment = .Left
        self.font = UIFont(name: "Helvetica Neue", size: 30)!
        self.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadPlaceHolder(placeHolder: String){
        self.text = placeHolder
        self.textColor = UIColor.lightGrayColor()
    }
    
    func loadText(text: String?) {
        self.text = text
        self.textColor = UIColor.blackColor()
    }
    
}

class EditTextItemViewController: UIViewController, UITextViewDelegate, UINavigationBarDelegate,  TextSettingViewControllerDelegate {
    
    var delegate: EditTextItemViewControllerDelegate?
    private var text: String! = EditTextItemViewController.placeHolder
    var textColour: UIColor = UIColor.blackColor()
    var textFont: UIFont = UIFont(name: "Helvetica Neue", size: 30)!
    var textAlignment: NSTextAlignment = .Left
    var textViewBackgroundColour: UIColor = UIColor.whiteColor()
    var settingVC: TextSettingViewController!

    private static let placeHolder: String = "Enter Your Text Here..."
    
    var editTextItemView: EditTextItemView!
    
    convenience init(){
        self.init(delegate: nil, text: nil, textAttribute: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(delegate: EditTextItemViewControllerDelegate?, text: String?, textAttribute: TextItemOtherAttribute?) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        
        initUI()
        initText(text, textAttribute: textAttribute)
    }
    
    
    private func initUI() {
        self.view = UIView(frame: CGRectMake(0,0,windowWidth, windowHeight))
        self.view.backgroundColor = UIColor.customBackgroundColor()
        
        let addButton = NavigationHelper.leftNavButton("Add", target: self, action: "addText")
        let settingButton = NavigationHelper.centerButton("Setting", target: self, action: "setting")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.titleView = settingButton
        
        editTextItemView = EditTextItemView(frame: CGRectMake(20,20, windowWidth - 40.0, windowHeight - 40.0))
        editTextItemView.delegate = self
        self.view.addSubview(editTextItemView)
        
        settingVC = TextSettingViewController(delegate: self, textAttribute: self.getTextAttribute())
    }
    
    private func initText(text: String?, textAttribute: TextItemOtherAttribute?) {
        if text == nil {
            self.text = text
            editTextItemView.loadPlaceHolder(EditTextItemViewController.placeHolder)
        }
        
        changeTextAndAttribute(text, textAttribute: textAttribute)
    }
    
    func addText() {
        self.dismiss(true)
        
        if let delegate = self.delegate {
            self.text = self.editTextItemView.text
            if self.text == EditTextItemViewController.placeHolder || self.text.isEmpty {
                self.text = "You didn't write anything..."
            }
            let textAttribute = TextItemOtherAttribute(colour: self.textColour, font: self.textFont, alignment: self.textAlignment)
            
            delegate.addText(self, text: self.text, textAttribute: textAttribute)
        }
    }
    
    func setting() {
        if let navController = self.navigationController {
            navController.pushViewController(settingVC, animated: true)
        } else {
            presentViewController(settingVC, animated: true, completion: nil)
        }
    }
    
    func changeTextAndAttribute(text: String?, textAttribute: TextItemOtherAttribute?) {
        if let text = text {
            changeText(text)
        }
        if let textAttr = textAttribute {
            changeTextColour(textAttr.colour)
            changeTextFont(textAttr.font)
            changeTextAlignment(textAttr.alignment)
        }
    }
    
    func changeText(text: String) {
        self.text = text
        if text == EditTextItemViewController.placeHolder {
            editTextItemView.loadText(self.text)
        } else {
            editTextItemView.loadPlaceHolder(self.text)
        }
    }
    
    func getTextAttribute() -> TextItemOtherAttribute {
        return TextItemOtherAttribute(colour: self.textColour, font: self.textFont, alignment: self.textAlignment)
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

