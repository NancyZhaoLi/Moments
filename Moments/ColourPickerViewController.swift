//
//  ColorPickerViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-26.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import SwiftHSVColorPicker

let barColour = UIColor(red: 8/255.0, green: 164/255.0, blue: 179/255.0, alpha: 1.0)
let windowHeight = UIScreen.mainScreen().bounds.height
let windowWidth = UIScreen.mainScreen().bounds.width


protocol ColourPickerViewControllerDelegate {
    func selectColor(controller: ColourPickerViewController, colour: UIColor)
}

class ColourPickerViewController: UIViewController {

    var colourPicker: SwiftHSVColorPicker!
    var delegate: ColourPickerViewControllerDelegate?
    
    convenience init() {
        self.init(initialColour: UIColor.whiteColor(), delegate: nil)
    }
    
    init(initialColour: UIColor?, delegate: ColourPickerViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.view = UIView(frame: CGRectMake(0,0,windowWidth,windowHeight))
        self.view.backgroundColor = UIColor.whiteColor()
        if let initialColour = initialColour {
            self.initUI(initialColour)
        } else {
            self.initUI(UIColor.whiteColor())
        }
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initUI(initialColour: UIColor) {
        self.initColourPicker(initialColour)
        self.initNavigationButtons()
    }
    
    func initColourPicker(initialColour: UIColor) {
        let colourPickerHeight = self.view.frame.height - 100
        let colourPickerWidth = self.view.frame.width - 20
        self.colourPicker = SwiftHSVColorPicker(frame: CGRectMake(10,100,colourPickerWidth,colourPickerHeight))
        self.colourPicker.setViewColor(initialColour)
        self.view.addSubview(self.colourPicker)
    }
    
    func initNavigationButtons() {
        let cancelButton = UIButton(frame: CGRectMake(0,3,60,37))
        let selectButton = UIButton(frame: CGRectMake(windowWidth - 58,3,55,37))
        
        cancelButton.addTarget(self, action: "cancelColourPicking", forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        selectButton.addTarget(self, action: "selectColour", forControlEvents: UIControlEvents.TouchUpInside)
        selectButton.setTitle("Select", forState: UIControlState.Normal)
        selectButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    
        let leftBarButton = UIBarButtonItem(customView: cancelButton)
        let rightBarButton = UIBarButtonItem(customView: selectButton)
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = leftBarButton
        navItem.rightBarButtonItem = rightBarButton
        
        let navBar = UINavigationBar(frame: CGRectMake(0,20,windowWidth, 44))
        navBar.barTintColor = barColour
        navBar.pushNavigationItem(navItem, animated: false)

        self.view.addSubview(navBar)
    }
    
    
    func cancelColourPicking() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectColour() {
        if let delegate = self.delegate {
            delegate.selectColor(self, colour: self.colourPicker.color)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
