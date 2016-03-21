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

class TextItemViewController: UIViewController, EditTextItemViewControllerDelegate {

    var manager: NewMomentManager?
    var parentVC: UIViewController!
    var editText: EditTextItemViewController!
    var dragBeginCoordinate: CGPoint?
    
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
        let width : CGFloat = UIScreen.mainScreen().bounds.size.width - 20 - location.x
        let height : CGFloat = ((CGFloat(text.length) / width) + 5) * 20
        
        let textItemView = UITextView(frame: CGRectMake(0,0, width, height))
        textItemView.center = location
        
        initEditTextItemViewController(text, textAttribute: textAttribute)
        initNewTextItemView(textItemView, text: text, textAttribute: textAttribute)
    }

    func addText(textItem: TextItemEntry) {
        let textItemView = UITextView(frame: textItem.frame)
        let text = textItem.content
        let textAttribute = TextItemOtherAttribute(colour: textItem.getTextColour(), font: textItem.getTextFont(), alignment: textItem.getTextAlignment())
        let zPosition = textItem.zPosition
        textItemView.layer.zPosition = CGFloat(zPosition)

        initEditTextItemViewController(text, textAttribute: textAttribute)
        initNewTextItemView(textItemView, text: text, textAttribute: textAttribute)
    }
    
    private func initNewTextItemView(textView: UITextView, text: String, textAttribute: TextItemOtherAttribute) {
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
    let pinchRec: UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    let rotateRec: UIRotationGestureRecognizer = UIRotationGestureRecognizer()
    let panRec: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    func initGestureRecognizer() {
        tapRec.addTarget(self, action: "tappedView")
        pinchRec.addTarget(self, action: "pinchedView:")
        rotateRec.addTarget(self, action: "rotatedView:")
        panRec.addTarget(parentVC, action: "draggedView:")
        
        self.view.addGestureRecognizer(tapRec)
        self.view.addGestureRecognizer(pinchRec)
        self.view.addGestureRecognizer(rotateRec)
        self.view.addGestureRecognizer(panRec)
        
        self.view.multipleTouchEnabled = true
    }
    
    func tappedView() {
        if let navController = parentVC.navigationController {
            navController.pushViewController(editText, animated: true)
        } else {
            parentVC.presentViewController(editText, animated: true, completion: nil)
        }
    }
    
    func pinchedView(sender: UIPinchGestureRecognizer) {
        if sender.state == .Began {
            
        } else if sender.state == .Changed {
            parentVC.view.bringSubviewToFront(self.view)
            sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
            sender.scale = 1.0
        }
    }
    
    func rotatedView(sender: UIRotationGestureRecognizer) {
        
        /*
        var lastRotation = CGFloat()
        self.view.bringSubviewToFront(self.view)
        if (sender.state == UIGestureRecognizerState.Ended) {
        lastRotation = 0.0;
        }
        
        let rotation = 0.0 - (lastRotation - sender.rotation)
        var point = rotateRec.locationInView(self.view)
        let currentTrans = sender.view!.transform
        let newTrans = CGAffineTransformRotate(currentTrans, rotation)
        sender.view!.transform = newTrans
        lastRotation = sender.rotation*/
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
