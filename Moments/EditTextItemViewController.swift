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

class EditTextSettingViewController : UIViewController, ColourPickerViewControllerDelegate, UINavigationBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var fontData : [String] = [String]()
    
    
    @IBAction func changeFontSize(sender: AnyObject) {
    }
    
    
    @IBAction func changeFontName(sender: AnyObject) {
        print("font name change?")
        let fontNamePicker = UIPickerView(frame: CGRect(x: 20, y: self.view.frame.height - 300, width: self.view.frame.width - 40, height: 300))
        fontNamePicker.delegate = self
        fontNamePicker.dataSource = self
        fontNamePicker.selectRow(self.selectedIndex, inComponent: 0, animated: false)
        
        self.view.addSubview(fontNamePicker)
        
    }
    
    @IBAction func setTextAlignment(sender: AnyObject) {
        
    }
    
    @IBAction func changeFontColour(sender: AnyObject) {
        print("colour change")
        let colourPickerVC = storyboard?.instantiateViewControllerWithIdentifier("colourPicker") as! ColourPickerViewController
        colourPickerVC.delegate = self
        self.presentViewController(colourPickerVC, animated: true, completion: nil)
    }

    @IBOutlet weak var textColour: UIButton!
    
    @IBOutlet weak var textSize: UILabel!
    
    @IBOutlet weak var textFont: UIButton!
    
    var selectedIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("load successfully")
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

class EditTextItemViewController: UIViewController, UITextViewDelegate, UINavigationBarDelegate {

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
            delegate.addText(self, textView: editTextItemView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.editTextItemView.delegate = self
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
