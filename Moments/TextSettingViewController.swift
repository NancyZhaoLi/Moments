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
    func changeTextColour(colour: UIColor)
    func changeTextFont(font: UIFont)
    func changeTextAlignment(alignment: NSTextAlignment)
    var textColour: UIColor { get }
    var textFont: UIFont { get }
    var textAlignment: NSTextAlignment { get }
}

class TextSettingViewController : UIViewController, ColourPickerViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate : TextSettingViewControllerDelegate?
    private var fontData : [String] = [String]()
    private var selectedFontIndex : Int = 0
    private var textAlignment: NSTextAlignment = .Left
    private var previousSelectedTextAlignmentButton: UIButton?
    
    @IBOutlet weak var textColour: UIButton!
    var textFontSize: UILabel?
    @IBOutlet weak var textFontName: UIButton!
    @IBOutlet weak var alignLeft: UIButton!
    @IBOutlet weak var alignCenter: UIButton!
    @IBOutlet weak var alignRight: UIButton!
    @IBOutlet weak var alignJustified: UIButton!
    @IBOutlet weak var textFontSizeSlider: UISlider!
    var sliderRange : Float?

    @IBAction func changeFontSize(sender: UISlider) {
        changeFontSize(sender.value)
    }
    
    @IBAction func changeFontColour(sender: AnyObject) {
        print("colour change")
        let colourPickerVC: ColourPickerViewController = ColourPickerViewController(initialColour: self.textColour.backgroundColor, delegate: self)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        UISetup()
        
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            let names = UIFont.fontNamesForFamilyName(familyName)
            for name in names {
                if name.componentsSeparatedByString("-").count == 1 {
                    fontData.append(name)
                }
            }
        }
        
        if let delegate = self.delegate {
            self.textColour.backgroundColor = delegate.textColour
            let textFont = delegate.textFont
            setFontName(textFont.fontName)
            setFontSize(textFont.pointSize)
            setTextAlignment(delegate.textAlignment)
        } else {
            print("delegate not set!!!")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue")
        if segue.identifier == "unwindToEditText" {
            print("unwind")
            if let delegate = self.delegate {
                delegate.changeTextColour(getTextColour())
                delegate.changeTextFont(getTextFont())
                delegate.changeTextAlignment(self.textAlignment)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Private Setter Functions
    private func setFontName(fontName: String) {
        self.textFontName.setTitle(fontName, forState: UIControlState.Normal)
        for var index = 0; index < fontData.count; ++index {
            if fontData[index] == fontName {
                self.selectedFontIndex = index
                break
            }
        }
    }
    
    private func setFontSize(fontSize: CGFloat) {
        let fontSize = Float(fontSize)
        self.changeFontSize(fontSize)
    }
    
    private func setTextAlignment(alignment: NSTextAlignment) {
        print("alignment: " + String(alignment))
        if alignment == .Left { changeTextAlignmentToLeft(self) }
        else if alignment == .Center { changeTextAlignmentToCenter(self) }
        else if alignment == .Right { changeTextAlignmentToRight(self) }
        else { changeTextAlignmentToJustified(self) }
    }
    
    
    // Internal Getter Functions
    private func getTextColour() -> UIColor {
        if let colour = textColour.backgroundColor {
            return colour
        }
        
        return UIColor.blackColor()
    }
    
    private func getTextFont() -> UIFont {
        return UIFont(name: getFontName(), size: getFontSize())!
    }
    
    // Private Helper Functions
    private func UISetup() {
        self.sliderRange = self.textFontSizeSlider.maximumValue - self.textFontSizeSlider.minimumValue
        self.textFontSize = UILabel(frame: CGRectMake(0, 158, 21, 21))
        self.view.addSubview(self.textFontSize!)
    }
    
    private func getFontSize() -> CGFloat {
        if let size = Int(self.textFontSize!.text!) {
            return CGFloat(integerLiteral: size)
        }
        return CGFloat(30)
    }
    
    private func getFontName() -> String {
        if let label = textFontName.titleLabel?.text {
            return label
        }
        return "Helvetica"
    }
    
    private func unsetButtonSelected(button: UIButton?) {
        if let button = button {
            //button.setTitle(button.titleLabel?.text, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.backgroundColor = UIColor.clearColor()
        }
    }
    
    private func setButtonSelected(button: UIButton) {
        unsetButtonSelected(self.previousSelectedTextAlignmentButton)
        //button.setTitle(button.titleLabel?.text, forState: UIControlState.Selected)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blueColor()
        self.previousSelectedTextAlignmentButton = button
    }
    
    private func changeFontSize(curValue: Float) {
        if let textFontSize = self.textFontSize {
            textFontSize.text = String(Int(curValue))
            let moveLeft: CGFloat = textFontSizeSlider.frame.origin.x - 21.0 + CGFloat((curValue/self.sliderRange!)) * textFontSizeSlider.frame.size.width
            textFontSize.frame = CGRectMake(moveLeft, 158, 21, 21)
        }
    }
    
    // Colour Picker Delegate
    func selectColor(controller: ColourPickerViewController, colour: UIColor) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        textColour.backgroundColor = colour
        print(colour)
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
        
        sleep(2)
        
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



