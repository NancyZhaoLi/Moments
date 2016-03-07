//
//  EditTextItemSettingViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-03-07.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class EditTextItemSettingViewController : UIViewController, ColourPickerViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var fontData : [String] = [String]()
    var parentVC : EditTextItemViewController?
    //var textSize : Int?
    //var textColour: UIColor?
    //var textFont: String?
    //var textAlignment: NSTextAlignment?
    
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
        fontNamePicker.selectRow(self.selectedIndex, inComponent: 0, animated: false)
        
        self.view.addSubview(fontNamePicker)
    }
    
    @IBAction func changeTextAlignment(sender: AnyObject) {
        
    }

    @IBOutlet weak var textColour: UIButton!
    
    @IBOutlet weak var textFontSize: UILabel!
    
    @IBOutlet weak var textFontName: UIButton!
    
    var selectedIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            let names = UIFont.fontNamesForFamilyName(familyName)
            for name in names {
                if name.componentsSeparatedByString("-").count == 1 {
                    if name == textFont.titleLabel!.text! {
                        self.selectedIndex = fontData.count
                    }
                    fontData.append(name)
                }
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidDisappear(animated: Bool) {
        self.parentVC!.changeTextItemSetting(self)
    }
    
    // Getter function
    func getColour() -> UIColor {
        if let colour = textColour.backgroundColor {
            return colour
        }
        
        return UIColor.blackColor()
    }
    
    func getFontSize() -> CGFloat {
        
    }
    
    func getFontName() -> String {
        if let label = textFontName.titleLabel?.text {
            return label
        }
        
        return "Helvetica"
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
        textFont.setTitle(fontData[row], forState: UIControlState.Normal)
        self.selectedIndex = row
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



