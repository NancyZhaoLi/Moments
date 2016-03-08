//
//  EditTextItemSettingViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-03-07.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

protocol TextSettingViewControllerDelegate {
    var textColour: UIColor { get set }
    var textFont: UIFont { get set }
    var textAlignment: NSTextAlignment { get set }
    func changeTextItemSetting(controller: TextSettingViewController)
}

class TextSettingViewController : UIViewController, ColourPickerViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : TextSettingViewControllerDelegate?
    var fontData : [String] = [String]()
    
    //var textSize : Int?
    //var textColour: UIColor?
    //var textFont: String?
    var textAlignment: NSTextAlignment?
    var previousSelectedTextAlignmentButton: UIButton?
    @IBOutlet weak var textColour: UIButton!
    @IBOutlet weak var textFontSize: UILabel!
    @IBOutlet weak var textFontName: UIButton!
    @IBOutlet weak var alignLeft: UIButton!
    @IBOutlet weak var alignCenter: UIButton!
    @IBOutlet weak var alignRight: UIButton!
    @IBOutlet weak var alignJustified: UIButton!

    @IBAction func changeFontSize(sender: AnyObject) {
    }
    
    @IBAction func changeFontColour(sender: AnyObject) {
        print("colour change")
        let colourPickerVC = storyboard?.instantiateViewControllerWithIdentifier("colourPicker") as! ColourPickerViewController
        colourPickerVC.delegate = self
        self.presentViewController(colourPickerVC, animated: true, completion: nil)
    }
    
    @IBAction func changeFontName(sender: AnyObject) {
        print("font name change?")
        let fontNamePicker = UIPickerView(frame: CGRect(x: 20, y: self.view.frame.height - 300, width: self.view.frame.width - 40, height: 300))
        fontNamePicker.delegate = self
        fontNamePicker.dataSource = self
        fontNamePicker.selectRow(self.selectedFontIndex, inComponent: 0, animated: false)
        
        self.view.addSubview(fontNamePicker)
    }
    
    
    @IBAction func changeTextAlignmentToLeft(sender: AnyObject) {
        self.textAlignment = .Left
        setButtonSelected(alignLeft)

    }
    @IBAction func changeTextAlignmentToCenter(sender: AnyObject) {
        self.textAlignment = .Center
        setButtonSelected(alignCenter)
    }
    @IBAction func changeTextAlignmentToRight(sender: AnyObject) {
        self.textAlignment = .Right
        setButtonSelected(alignRight)
    }
    @IBAction func changeTextAlignmentToJustified(sender: AnyObject) {
        self.textAlignment = .Justified
        setButtonSelected(alignJustified)
    }
    
    func unsetButtonSelected(button: UIButton?) {
        if let button = button {
            button.setTitle(button.titleLabel?.text, forState: UIControlState.Normal)
        }
    }
    
    func setButtonSelected(button: UIButton) {
        unsetButtonSelected(self.previousSelectedTextAlignmentButton)
        button.setTitle(button.titleLabel?.text, forState: UIControlState.Selected)
        self.previousSelectedTextAlignmentButton = button
    }

    
    var selectedFontIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            let names = UIFont.fontNamesForFamilyName(familyName)
            for name in names {
                if name.componentsSeparatedByString("-").count == 1 {
                    fontData.append(name)
                }
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if let delegate = self.delegate {
            let textColour = delegate.textColour
            self.textColour.backgroundColor = textColour
            
            let textFont = delegate.textFont
            setFontName(textFont.fontName)
            setFontSize(textFont.pointSize)
            
        } else {
            print("delegate not set!!!")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(animated: Bool) {
        if let delegate = self.delegate {
            delegate.changeTextItemSetting(self)
        }
    }
    
    
    func setFontName(fontName: String) {
        self.textFontName.setTitle(fontName, forState: UIControlState.Normal)
        for var index = 0; index < fontData.count; ++index {
            if fontData[index] == fontName {
                self.selectedFontIndex = index
                break
            }
        }
    }
    
    func setFontSize(fontSize: CGFloat) {
        let fontSize = String(Int(fontSize))
        self.textFontSize.text = fontSize
        // move slider
    }
    
    
    // Getter function
    func getTextColour() -> UIColor {
        if let colour = textColour.backgroundColor {
            return colour
        }
        
        return UIColor.blackColor()
    }
    
    func getFont() -> UIFont {
        return UIFont(name: getFontName(), size: getFontSize())!
    }
    
    internal func getFontSize() -> CGFloat {
        if let size = Int(self.textFontSize.text!) {
            return CGFloat(integerLiteral: size)
        }
        return CGFloat(30)
    }
    
    internal func getFontName() -> String {
        if let label = textFontName.titleLabel?.text {
            return label
        }
        
        return "Helvetica"
    }
    
    func getTextAlignment() -> NSTextAlignment {
        return .Left
    }
    
    
    // Colour Picker Delegate
    func selectColor(controller: ColourPickerViewController, colour: UIColor) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        textColour.backgroundColor = colour
    }
    
    func currentColor() -> UIColor {
        if let colour = textColour.backgroundColor {
            print("current color is: " + String(colour))
            return colour
        }
        
        return UIColor.blackColor()
    }     
    

    
    // Picker Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontData.count
    }
    
    
    
    // Picker Delegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fontData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Monica changed this:
        //From:textFont.setTitle(fontData[row], forState: UIControlState.Normal)
        //To:textFontName.setTitle(fontData[row], forState: UIControlState.Normal)
        textFontName.setTitle(fontData[row], forState: UIControlState.Normal)
        self.selectedFontIndex = row
        pickerView.removeFromSuperview()
    }
    
    
    /*func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let titleData = fontData[row]
    let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
    return myTitle
    }*/
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            pickerLabel.backgroundColor = UIColor.whiteColor()
        }
        let titleData = fontData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 26.0)!,NSForegroundColorAttributeName:UIColor(red: CGFloat(8/255.0), green: CGFloat(164/255.0), blue: CGFloat(179/255.0), alpha: 1.0)])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        
        return pickerLabel
        
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width - 80
    }
    
}



