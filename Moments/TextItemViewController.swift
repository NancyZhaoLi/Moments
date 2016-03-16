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

    var manager: TextItemManager!
    var parentView: UIView!
    var editViewNavController: EditTextItemNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(manager: TextItemManager())
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(manager: TextItemManager) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
        if !initParentView() {
            fatalError("ERROR: [TextItemViewController] parentView init failed")
        }
        
        if !initEditView() {
            fatalError("ERROR: [TextItemViewController] editView init failed")
        }
    }
    
    func initParentView() -> Bool {
        if let canvas = self.manager.canvas, view = canvas.view {
            self.parentView = view
            return true
        }
        return false
    }
    
    func initEditView() -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navController = storyboard.instantiateViewControllerWithIdentifier("editTextItem") as? EditTextItemNavigationController {
            self.editViewNavController = navController
            return true
        }
        return false
    }
    
    func addText(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute ) {
        let width : CGFloat = UIScreen.mainScreen().bounds.size.width - 20 - location.x
        let height : CGFloat = ((CGFloat(text.length) / width) + 5) * 20
        
        let textItemView = UITextView(frame: CGRectMake(location.x, location.y, width, height))
        
        initNewTextItemView(textItemView, text: text, textAttribute: textAttribute)
    }

    func addText(textItem: TextItemEntry) {
        let textItemView = UITextView(frame: textItem.getFrame())
        let text = textItem.getContent()
        let textAttribute = TextItemOtherAttribute(colour: textItem.getTextColour(), font: textItem.getTextFont(), alignment: textItem.getTextAlignment())

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
        if let editView = self.editViewNavController.topViewController as? EditTextItemViewController {
            editView.changeTextAndAttribute(text, textAttribute: textAttribute)
        } else {
            fatalError("ERROR: [TextItemViewController] - cannot find the EditTextItemViewController")
        }
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
        panRec.addTarget(self, action: "draggedView:")
        
        self.view.addGestureRecognizer(tapRec)
        self.view.addGestureRecognizer(pinchRec)
        self.view.addGestureRecognizer(rotateRec)
        self.view.addGestureRecognizer(panRec)
        
        self.view.userInteractionEnabled = false
        self.view.multipleTouchEnabled = true
    }
    
    func tappedView() {
        self.editViewNavController.viewDelegate = self
        self.presentViewController(editViewNavController, animated: true, completion: nil)
        if let textView = self.view as? UITextView {
            let textAttribute = TextItemOtherAttribute(colour: textView.textColor!, font: textView.font!, alignment: textView.textAlignment)
            initEditTextItemViewController(textView.text, textAttribute: textAttribute)
        }
    }
    
    func pinchedView(sender: UIPinchGestureRecognizer) {
        parentView.bringSubviewToFront(self.view)
        sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 0.5
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
    
    func draggedView(sender: UIPanGestureRecognizer) {
        if let senderView = sender.view {
            parentView.bringSubviewToFront(senderView)
            let translation = sender.translationInView(parentView)
            senderView.center = CGPointMake(senderView.center.x + translation.x, senderView.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: parentView)
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
