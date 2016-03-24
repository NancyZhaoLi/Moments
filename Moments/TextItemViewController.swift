//
//  TextItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

extension String {
    var length: Int {
        return characters.count
    }
}

enum PinchMode {
    case Horizontal
    case Vertical
    case Diagonal
}


class TextItemView: UITextView {
    var beginPinchCoor: [CGPoint] = [CGPoint]()
}



class TextItemViewController: UIViewController, EditTextItemViewControllerDelegate {

    var manager: NewMomentManager?
    var parentVC: UIViewController!
    var editText: EditTextItemViewController!
    var dragBeginCoordinate: CGPoint?
    
    var tapToTrashGR: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(manager: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(manager: NewMomentManager?) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
        if !initParentView() {
            fatalError("ERROR: [TextItemViewController] parentVC init failed")
        }
        
        initEditView()
    }
    
    private func initParentView() -> Bool {
        if let canvas = manager!.canvasVC {
            parentVC = canvas
            return true
        }
        return false
    }
    
    private func initEditView() {
        editText = EditTextItemViewController(delegate: self, text: nil, textAttribute: nil)
    }
    
    func addText(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute ) {
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
        initNewTextItemView(textItemView, text: text, textAttribute: textAttribute)
    }

    func addText(textItem: TextItem) {
        let textItemView = TextItemView(frame: textItem.getFrame())
        let text = textItem.getContent()
        let textAttribute = textItem.getOtherAttribute()
        let zPosition = textItem.zPosition
        textItemView.layer.zPosition = CGFloat(zPosition)
        
        if let attr = textAttribute {
            initEditTextItemViewController(text, textAttribute: attr)
            initNewTextItemView(textItemView, text: text, textAttribute: attr)
        } else {
            let attr = TextItemOtherAttribute()
            initEditTextItemViewController(text, textAttribute: attr)
            initNewTextItemView(textItemView, text: text, textAttribute: attr)
        }
    }
    
    private func initNewTextItemView(textView: TextItemView, text: String, textAttribute: TextItemOtherAttribute) {
        self.view = textView
        changeText(text, textAttribute: textAttribute)
        textView.backgroundColor = UIColor.clearColor()
        textView.editable = false		

        initGestureRecognizer()
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
    
    /*********************************************************************************

        GESTURE RECOGNIZERS

    *********************************************************************************/
    
    let tapRec: UITapGestureRecognizer = UITapGestureRecognizer()
    
    func initGestureRecognizer() {
        tapRec.addTarget(self, action: "tappedView")
        self.view.addGestureRecognizer(tapRec)
    }
    
    func tappedView() {
        if let navController = parentVC.navigationController {
            navController.pushViewController(editText, animated: true)
        } else {
            parentVC.presentViewController(editText, animated: true, completion: nil)
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
