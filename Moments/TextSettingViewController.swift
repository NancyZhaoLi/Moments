//
//  EditTextItemSettingViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-07.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

protocol TextSettingViewControllerDelegate {
    func changeTextColour(colour: UIColor)
    func changeTextFont(font: UIFont)
    func changeTextAlignment(alignment: NSTextAlignment)
}


class TextSettingViewController : UIViewController,
    ColourPickerViewControllerDelegate,
    UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var delegate : TextSettingViewControllerDelegate?
    private var textAttribute: TextItemOtherAttribute!
    
    private var textFontSize: UILabel!
    private var textFontSizeSlider: UISlider!
    private var sliderRange : CGFloat!
    
    private var fontData : [String] = [String]()
    private var fontNamePicker: UIPickerView!
    private var pickerPresent: Bool!
    private var textFontName: UIButton!
    
    private var textColour: UIButton!
    private var colourPicker: ColourPickerViewController!
    
    private var alignmentGroup: [UIButton]! = [UIButton]()
    private var previousSelectedTextAlignmentIndex: Int?
    private let alignmentselectedImage: [String] = ["text.png", "text.png", "text.png", "text.png"]
    private let alignmentUnselectedImage: [String] = ["text.png", "text.png", "text.png", "text.png"]
    
    let inset: CGFloat! = 20.0

    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(delegate: nil, textAttribute: TextItemOtherAttribute())
    }
    
    init?(delegate: TextSettingViewControllerDelegate?, textAttribute: TextItemOtherAttribute) {
        super.init(nibName: nil, bundle: nil)
        
        if delegate == nil {
            return nil
        }
        self.delegate = delegate!
        self.textAttribute = textAttribute

        print("before initUI")
        initUI()
        print("after initUI")
    }
    
    
    func initUI() {
        self.view = UIView(frame: CGRectMake(0,0,windowWidth, windowHeight))
        self.view.backgroundColor = UIColor.customBackgroundColor()
        let backButton = NavigationHelper.leftNavButton("Back", target: self, action: "goBack")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        let groupFirstY: CGFloat = 90.0
        let groupHeight: CGFloat = 120.0
        let groupNum: Int = 4
        let headerSize: CGFloat = 21.0
        let lineHeight: CGFloat = 3.0
        let contentFrame = CGRectMake(inset,0, windowWidth - 2 * inset, 40.0)
        
        let groupHeader: [String] = ["Size", "Colour", "Font", "Alignment"]
        var groupContent: [UIView] = [UIView]()
        
        let sizeContent = initSizeContent(contentFrame)
        let colourContent = initColourContent(contentFrame)
        let fontContent = initFontContent(contentFrame)
        let alignmentContent = initAlignmentContent(contentFrame)
        
        groupContent.append(sizeContent)
        groupContent.append(colourContent)
        groupContent.append(fontContent)
        groupContent.append(alignmentContent)

        for var count = 0; count < groupNum; count++ {
            let y = groupFirstY + CGFloat(count) * groupHeight
            let groupView = UIHelper.groupWithHeader(groupHeader[count], headerSize: headerSize, lineHeight: lineHeight, inset: inset, y: y, content: groupContent[count])
            print(groupView)
            self.view.addSubview(groupView)
        }
    }
    
    private func initSizeContent(contentFrame: CGRect) -> UIView {
        let largeTextSize = UIHelper.textSize("AA", size: 30.0)
        let sliderHeight = largeTextSize.height
        let smallTextSize = CGSizeMake(UIHelper.textWidth("AA", size: 15.0), sliderHeight)
        
        let largeTextLabel = UILabel(frame: CGRect(origin: CGPointMake(windowWidth - 2 * inset - largeTextSize.width,0), size: largeTextSize))
        let smallTextLabel = UILabel(frame: CGRect(origin: CGPointMake(0,0), size: smallTextSize))
        
        largeTextLabel.text = "A"
        largeTextLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30.0)
        largeTextLabel.textColor = UIColor.blackColor()
        largeTextLabel.textAlignment = .Center
        largeTextLabel.backgroundColor = UIColor.clearColor()
        
        smallTextLabel.text = "A"
        smallTextLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        smallTextLabel.textColor = UIColor.blackColor()
        smallTextLabel.textAlignment = .Center
        smallTextLabel.backgroundColor = UIColor.clearColor()

        
        let sliderOrigin = CGPointMake(smallTextLabel.frame.maxX + 5.0,0)
        let sliderWidth = largeTextLabel.frame.minX - smallTextLabel.frame.maxX - 5
        let sliderSize = CGSizeMake(sliderWidth,sliderHeight)
        
        textFontSizeSlider = UISlider(frame: CGRect(origin: sliderOrigin, size: sliderSize))
        textFontSizeSlider.minimumValue = 5.0
        textFontSizeSlider.maximumValue = 80.0
        textFontSizeSlider.value = Float(textAttribute.font.pointSize)
        textFontSizeSlider.continuous = true
        sliderRange = CGFloat(textFontSizeSlider.maximumValue - textFontSizeSlider.minimumValue)
        textFontSizeSlider.backgroundColor = UIColor.customGreenColor()
        textFontSizeSlider.addTarget(self, action: "changeFontSize", forControlEvents: UIControlEvents.ValueChanged)
        
        textFontSize = UILabel(frame: CGRect(origin: CGPointMake(0,textFontSizeSlider.frame.maxY + 1), size: UIHelper.textSize("300", size: 15.0)))
        textFontSize.textAlignment = .Center
        textFontSize.font = UIFont.systemFontOfSize(15.0)
        textFontSize.textColor = UIColor.blackColor()
        changeFontSize()
        
        let sizeContentView = UIView(frame: contentFrame)
        sizeContentView.frame.size.width += 15.0
        sizeContentView.addSubview(smallTextLabel)
        sizeContentView.addSubview(largeTextLabel)
        sizeContentView.addSubview(textFontSizeSlider)
        sizeContentView.addSubview(textFontSize)
        
        return sizeContentView
    }
    
    private func initColourContent(contentFrame: CGRect) -> UIView {
        textColour = ButtonHelper.textButton("", frame: contentFrame, target: self, action: "changeFontColour")
        textColour.backgroundColor = textAttribute.colour
        
        colourPicker = ColourPickerViewController(initialColour: textAttribute.colour, delegate: self)
        
        return textColour
    }

    private func initFontContent(contentFrame: CGRect) -> UIView {
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            let names = UIFont.fontNamesForFamilyName(familyName)
            for name in names {
                if name.componentsSeparatedByString("-").count == 1 {
                    fontData.append(name)
                }
            }
        }

        textFontName = ButtonHelper.whiteTextButton("", frame: contentFrame, target: self, action: "changeFontName")
        textFontName.backgroundColor = UIColor.whiteColor()
        
        let fontName = textAttribute.font.fontName
        var selectedFontIndex = 0
        textFontName.setTitle(fontName, forState: UIControlState.Normal)
        for var index = 0; index < fontData.count; ++index {
            if fontData[index] == fontName {
                selectedFontIndex = index
                break
            }
        }
        
        print(selectedFontIndex)
        print(fontName)
        
        fontNamePicker = UIPickerView(frame: CGRect(x: 20, y: self.view.frame.height - 300, width: self.view.frame.width - 40, height: 300))
        fontNamePicker.delegate = self
        fontNamePicker.dataSource = self
        fontNamePicker.selectRow(selectedFontIndex, inComponent: 0, animated: false)
        pickerPresent = false
        
        return textFontName
    }
    
    func initAlignmentContent(contentFrame: CGRect) -> UIView {
        let alignmentGroupNum = 4

        let alignmentGroupSelector: [Selector] = ["alignToLeft", "alignToCenter", "alignToRight", "alignToJustified"]
        let alignmentGroupCenters: [CGPoint] = ToolbarHelper.getCenter(contentFrame.height/2.0, totalItems: 4, inset: inset)
        let alignmentGroupView = UIView(frame: CGRectMake(0,0,windowWidth, contentFrame.height))
        
        for var count = 0; count < alignmentGroupNum; count++ {
            let button = ButtonHelper.imageButton(alignmentUnselectedImage[count], center: alignmentGroupCenters[count], imageSize: contentFrame.height, target: self, action: alignmentGroupSelector[count])
            alignmentGroup.append(button)
            alignmentGroupView.addSubview(button)
        }
        
        let alignment = textAttribute.alignment
        if alignment == .Left { alignToLeft() }
        else if alignment == .Center { alignToCenter() }
        else if alignment == .Right { alignToRight() }
        else { alignToJustified() }
        
        return alignmentGroupView
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if pickerPresent == true {
            fontNamePicker.removeFromSuperview()
            pickerPresent = false
        }
    }
    

    func goBack() {
        print("go back")
        self.dismiss(true)
        
        delegate!.changeTextColour(textAttribute.colour)
        delegate!.changeTextFont(textAttribute.font)
        delegate!.changeTextAlignment(textAttribute.alignment)
    }
    
    func changeFontSize() {
        let curValue: CGFloat = CGFloat(textFontSizeSlider.value)
        
        textAttribute.font = UIFont(name: textAttribute.font.familyName, size: curValue)!
        textFontSize.text = String(Int(curValue))
        let moveLeft: CGFloat = textFontSizeSlider.frame.origin.x + curValue/sliderRange * textFontSizeSlider.frame.size.width
        textFontSize.center = CGPointMake(moveLeft, textFontSize.center.y)
    }
    
    func changeFontColour() {
        presentViewController(colourPicker, animated: true, completion: nil)
    }
    
    func changeFontName() {
        if !pickerPresent {
            pickerPresent = true
            view.addSubview(fontNamePicker)
        }
    }
    
    func alignToLeft() {
        textAttribute.alignment = .Left
        setButtonSelected(0)
    }
    
    func alignToCenter() {
        textAttribute.alignment = .Center
        setButtonSelected(1)
    }
    
    func alignToRight() {
        textAttribute.alignment = .Right
        setButtonSelected(2)
    }
    
    func alignToJustified() {
        textAttribute.alignment = .Justified
        setButtonSelected(3)
    }
    
    private func unsetButtonSelected() {
        if let index = previousSelectedTextAlignmentIndex {
            let button = alignmentGroup[index]
            let image = UIImage(named: alignmentUnselectedImage[index])
            button.setImage(image, forState: .Normal)
        }
    }
    
    private func setButtonSelected(index: Int) {
        unsetButtonSelected()
        let button = alignmentGroup[index]
        let image = UIImage(named: alignmentselectedImage[index])
        button.setImage(image, forState: .Normal)
        previousSelectedTextAlignmentIndex = index
    }

    /***************************************************************************************
     
     DELEGATE FUNCTIONS

    ***************************************************************************************/
    
    // Colour Picker Delegate
    func selectColor(controller: ColourPickerViewController, colour: UIColor) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        textAttribute.colour = colour
        textColour.backgroundColor = colour
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
        let newFontName = fontData[row]
        textAttribute.font = UIFont(name: newFontName, size: textAttribute.font.pointSize)!
        textFontName.setTitle(newFontName, forState: UIControlState.Normal)
        
        sleep(1)
        pickerPresent = false
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



