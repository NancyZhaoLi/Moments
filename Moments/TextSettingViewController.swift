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
    
    private var preview: UILabel = UILabel()
    
    private var textColour: UIButton!
    private var colourPicker: ColourPickerViewController!
    
    private var alignmentGroup: [UIButton]! = [UIButton]()
    private var previousSelectedTextAlignmentIndex: Int?
    private let alignmentselectedImage: [String] = ["align_left_selected.png", "align_center_selected.png", "align_right_selected.png", "align_sides_selected.png"]
    private let alignmentUnselectedImage: [String] = ["align_left.png", "align_center.png", "align_right.png", "align_sides.png"]
    
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
        initUI()
    }
    
    private func reloadAttribute(textAttribute: TextItemOtherAttribute) {
        self.textAttribute = textAttribute
        initUI()
    }
    
    private func initUI() {
        self.view = UIView(frame: CGRectMake(0,0,windowWidth, windowHeight))
        self.view.backgroundColor = UIColor.customBackgroundColor()
        let backButton = NavigationHelper.leftNavButton("Back", target: self, action: "goBack")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        let groupFirstY: CGFloat = 90.0
        let groupHeight: CGFloat = 95.0
        let groupNum: Int = 4
        let headerSize: CGFloat = 21.0
        let lineHeight: CGFloat = 3.0
        let contentFrame = CGRectMake(inset,0, windowWidth - 2 * inset, 25.0)
        
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

        var maxY: CGFloat = 0.0
        
        for var count = 0; count < groupNum; count++ {
            let y = groupFirstY + CGFloat(count) * groupHeight
            let groupView = UIHelper.groupWithHeader(groupHeader[count], headerSize: headerSize, lineHeight: lineHeight, inset: inset, y: y, content: groupContent[count])
            maxY = groupView.frame.maxY
            self.view.addSubview(groupView)
        }
        
        fontNamePicker.backgroundColor = UIColor.customBackgroundColor()
        
        initPreview(maxY)
    }
    
    
    private func initPreview(maxY: CGFloat) {
        let previewBox = UIView(frame: CGRectMake(20, maxY + 25.0, windowWidth - 40.0, windowHeight - maxY - 50.0))
        preview = UILabel(frame: CGRectMake(20.0, 10.0, previewBox.frame.size.width - 40.0, previewBox.frame.size.height - 20.0))
        preview.text = "Sample Text 1"
        preview.font = textAttribute.font
        preview.textColor = textAttribute.colour
        preview.textAlignment = textAttribute.alignment
        
        previewBox.backgroundColor = UIColor.whiteColor()
        previewBox.layer.borderColor = UIColor.blackColor().CGColor
        previewBox.layer.borderWidth = 3.0
        previewBox.layer.cornerRadius = 10.0
        previewBox.layer.masksToBounds = true
        
        previewBox.addSubview(preview)
        self.view.addSubview(previewBox)
    }
    
    private func initSizeContent(contentFrame: CGRect) -> UIView {
        let largeTextFont = UIFont(name: "HelveticaNeue-Bold", size: 30.0)!
        let smallTextFont = UIFont(name: "HelveticaNeue-Bold", size: 15.0)!
        let largeTextSize = UIHelper.textSize("A", font: largeTextFont)
        let sliderHeight = largeTextSize.height
        let smallTextSize = CGSizeMake(UIHelper.textSize("A", font: smallTextFont).width, sliderHeight)
        
        let largeTextLabel = UILabel(frame: CGRect(origin: CGPointMake(windowWidth - 2 * inset - largeTextSize.width,0), size: largeTextSize))
        let smallTextLabel = UILabel(frame: CGRect(origin: CGPointMake(0,0), size: smallTextSize))
        
        largeTextLabel.text = "A"
        largeTextLabel.font = largeTextFont
        largeTextLabel.textColor = UIColor.blackColor()
        largeTextLabel.textAlignment = .Center
        largeTextLabel.backgroundColor = UIColor.clearColor()
        
        smallTextLabel.text = "A"
        smallTextLabel.font = smallTextFont
        smallTextLabel.textColor = UIColor.blackColor()
        smallTextLabel.textAlignment = .Center
        smallTextLabel.backgroundColor = UIColor.clearColor()
        
        let sliderOrigin = CGPointMake(smallTextLabel.frame.maxX + 5.0,0)
        let sliderWidth = largeTextLabel.frame.minX - smallTextLabel.frame.maxX - 10.0
        let sliderSize = CGSizeMake(sliderWidth,sliderHeight)
        
        textFontSizeSlider = UISlider(frame: CGRect(origin: sliderOrigin, size: sliderSize))
        textFontSizeSlider.minimumValue = 10.0
        textFontSizeSlider.maximumValue = 70.0
        textFontSizeSlider.value = Float(textAttribute.font.pointSize)
        textFontSizeSlider.continuous = true
        sliderRange = CGFloat(textFontSizeSlider.maximumValue - textFontSizeSlider.minimumValue)
        textFontSizeSlider.backgroundColor = UIColor.customGreenColor()
        textFontSizeSlider.addTarget(self, action: "changeFontSize", forControlEvents: UIControlEvents.ValueChanged)
        
        let textSize = UIHelper.textSize("30", size: 15.0)
        textFontSize = UILabel(frame: CGRect(origin: CGPointMake(0,textFontSizeSlider.frame.maxY + 1), size: CGSizeMake(textSize.width + 3.0, textSize.height)))
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
        
        fontData.sortInPlace()
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
        self.dismiss(true)
        
        delegate!.changeTextColour(textAttribute.colour)
        delegate!.changeTextFont(textAttribute.font)
        delegate!.changeTextAlignment(textAttribute.alignment)
    }
    

    func changeFontSize() {
        let curValue: CGFloat = CGFloat(textFontSizeSlider.value)
        let minValue: CGFloat = CGFloat(textFontSizeSlider.minimumValue)
        let offset: CGFloat = 15.0
        
        textAttribute.font = UIFont(name: textAttribute.font.familyName, size: curValue)!
        preview.font = textAttribute.font
        textFontSize.text = String(Int(curValue))
        
        let difference = curValue - minValue
        let beginX = textFontSizeSlider.frame.minX + offset
        let width = textFontSizeSlider.frame.size.width - offset * 2.0
        let moveLeft: CGFloat = beginX + difference / sliderRange * width
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
        preview.textAlignment = textAttribute.alignment
        setButtonSelected(0)
    }
    
    func alignToCenter() {
        textAttribute.alignment = .Center
        preview.textAlignment = textAttribute.alignment
        setButtonSelected(1)
    }
    
    func alignToRight() {
        textAttribute.alignment = .Right
        preview.textAlignment = textAttribute.alignment
        setButtonSelected(2)
    }
    
    func alignToJustified() {
        textAttribute.alignment = .Justified
        preview.textAlignment = textAttribute.alignment
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
        preview.textColor = textAttribute.colour
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
        preview.font = textAttribute.font
        textFontName.setTitle(newFontName, forState: UIControlState.Normal)
        
        sleep(1)
        pickerPresent = false
        pickerView.removeFromSuperview()
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {
            pickerLabel = UILabel()
            pickerLabel.backgroundColor = UIColor.customGreenColor()
        }
        let titleData = fontData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: titleData, size: 21.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center

        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width - 40
    }
    
}



