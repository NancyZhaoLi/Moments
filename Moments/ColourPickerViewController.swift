//
//  ColorPickerViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-26.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import SwiftHSVColorPicker

extension UIColor {
    static func customGreenColor() -> UIColor {
        return UIColor(red: 8/255.0, green: 164/255.0, blue: 179/255.0, alpha: 1.0)
    }
    static func customBlueColor() -> UIColor {
        return UIColor(red: 0.2, green: 0.211765, blue: 0.286275, alpha: 1.0)
    }
    static func customBackgroundColor() -> UIColor {
        return UIColor(red: 1.0, green: 1.0, blue: 246/255.0, alpha: 1.0)
    }
    static func customRedColor() -> UIColor {
        return UIColor(red: 1.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
    }
}

let windowHeight = UIScreen.mainScreen().bounds.height
let windowWidth = UIScreen.mainScreen().bounds.width


protocol ColourPickerViewControllerDelegate {
    func selectColor(controller: ColourPickerViewController, colour: UIColor)
}

class ColourPickerViewController: UIViewController {

    var colourPicker: SwiftHSVColorPicker!
    var delegate: ColourPickerViewControllerDelegate?
    var navItem: UINavigationItem?
    var navigationTitle: String?
    
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
        let cancelButton = NavigationHelper.leftNavButton("Cancel", target: self, action: "cancelColourPicking")
        let selectButton = NavigationHelper.rightNavButton("Select", target: self, action: "selectColour")

        let leftBarButton = UIBarButtonItem(customView: cancelButton)
        let rightBarButton = UIBarButtonItem(customView: selectButton)

        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = leftBarButton
        navItem.rightBarButtonItem = rightBarButton
        self.navItem = navItem
        
        let navBar = NavigationHelper.emptyBar()
        navBar.pushNavigationItem(navItem, animated: false)
        navBar.tintColor = UIColor.whiteColor()
        navBar.tintColor = UIColor.whiteColor()
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.view.addSubview(navBar)
    }
    
    func setNavigationBarTitle(title: String) {
        if let navItem = self.navItem {
            navItem.title = title
        }
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
