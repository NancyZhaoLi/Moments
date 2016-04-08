//
//  TextItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

extension String {
    var length: Int {
        return characters.count
    }
}

class TextItemView: UITextView {
    var beginPinchCoor: [CGPoint] = [CGPoint]()
    var item: NSManagedObject?
    var rotation: CGFloat = 0.0
    
    override func canBecomeFirstResponder() -> Bool {
        return false
    }
}

class TextItemViewController: ItemViewController, EditTextItemViewControllerDelegate {

    var editText: EditTextItemViewController!
    var dragBeginCoordinate: CGPoint?
    
    override init?(manager: NewMomentManager?) {
        super.init(manager: manager)
        initEditView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initEditView() {
        editText = EditTextItemViewController(delegate: self, text: nil, textAttribute: nil)
    }
    

    private func initNewTextItemView(textView: TextItemView, text: String, textAttribute: TextItemOtherAttribute, rotation: CGFloat) {
        self.view = textView
        changeText(text, textAttribute: textAttribute)
        textView.backgroundColor = UIColor.clearColor()
        textView.editable = false
        textView.rotation = rotation
        
        let currentTransform = textView.transform
        let newTransform = CGAffineTransformRotate(currentTransform, rotation)
        textView.transform = newTransform

        addTapToEditGR()
    }
    
    private func initEditTextItemViewController(text: String, textAttribute: TextItemOtherAttribute) {
        editText.changeTextAndAttribute(text, textAttribute: textAttribute)
    }
    
    private func changeText(text: String, textAttribute: TextItemOtherAttribute) {
        if let textView = self.view as? UITextView {
            textView.text = text
            textView.textColor = textAttribute.colour
            textView.font = textAttribute.font
            textView.textAlignment = textAttribute.alignment
        }
    }
    
    override func addItem(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute ) {
        // Computer text box size
        let maxHeight: CGFloat = 300.0
        let singleLineHeight: CGFloat = UIHelper.textSize("A", font: textAttribute.font).height
        let fullWidth: CGFloat = UIHelper.textSize(text, font: textAttribute.font).width
        let width: CGFloat = min(fullWidth + 20.0, windowWidth - 40.0)
        var height: CGFloat = ceil(fullWidth / width) * singleLineHeight + 20.0
        
        if height > maxHeight {
            height = maxHeight
        }
        
        let textItemView = TextItemView(frame: CGRectMake(0,0, width, height))
        textItemView.center = location
        textItemView.textContainer.lineBreakMode = .ByCharWrapping
        
        initEditTextItemViewController(text, textAttribute: textAttribute)
        initNewTextItemView(textItemView, text: text, textAttribute: textAttribute, rotation: 0.0)
        
        super.addToCanvas()
        self.addGR()
    }
    
    override func addItem(text text: TextItem) {
        let textItemView = TextItemView(frame: text.getFrame())
        let content = text.getContent()
        let textAttribute = text.getOtherAttribute()
        let zPosition = text.getZPosition()
        let rotation = text.getRotation()
        
        textItemView.layer.zPosition = CGFloat(zPosition)
        textItemView.item = text
        
        if let attr = textAttribute {
            initEditTextItemViewController(content, textAttribute: attr)
            initNewTextItemView(textItemView, text: content, textAttribute: attr, rotation: CGFloat(rotation))
        } else {
            let attr = TextItemOtherAttribute()
            initEditTextItemViewController(content, textAttribute: attr)
            initNewTextItemView(textItemView, text: content, textAttribute: attr, rotation: CGFloat(rotation))
        }
        
        super.addToCanvas(text.getZPosition())
        self.addGR()
    }
    
    let tapToEditGR: UITapGestureRecognizer = UITapGestureRecognizer()

    
    override func enableTrash(enabled: Bool) {
        super.enableTrash(enabled)
        tapToEditGR.enabled = !enabled
    }
    
    override func enableViewMode(enabled: Bool) {
        super.enableViewMode(enabled)
        tapToEditGR.enabled = !enabled
    }
    
    override func addPinchGR() {
        if let manager = self.manager {
            self.pinchGR =  manager.pinchTextGR()
            self.view.addGestureRecognizer(self.pinchGR!)
        }
    }
    
    override func tapToTrash(sender: UITapGestureRecognizer) {
        super.tapToTrash(sender)
    }
    
    private func addTapToEditGR() {
        tapToEditGR.addTarget(self, action: "tapToEdit")
        if let manager = self.manager {
            tapToEditGR.enabled = manager.enableInteraction
        }
        self.view.addGestureRecognizer(tapToEditGR)
    }
    
    func tapToEdit() {
        if let manager = self.manager {
            manager.presentViewController(editText, animated: true)
        }
    }
    


    /*********************************************************************************
     
        DELEGATE FUNCTIONS
     
     *********************************************************************************/
     
    // EditTextItemViewController Delegate functions
    func addText(controller: EditTextItemViewController, text: String, textAttribute: TextItemOtherAttribute) {
        changeText(text, textAttribute: textAttribute)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
