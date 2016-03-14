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
    var parentView: UIView?
    var editView: EditTextItemNavigationController?
    
    let tapRec: UITapGestureRecognizer = UITapGestureRecognizer()
    let pinchRec: UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    let rotateRec: UIRotationGestureRecognizer = UIRotationGestureRecognizer()
    let panRec: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(manager: TextItemManager) {
        super.init(nibName: nil, bundle: nil)
        self.manager = manager
        if setupParentView() {
            print("parentView setup successful in initializing TextItemViewController")
        } else {
            print("parentView setup failed in initializing TextItemViewController")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.editView = storyboard.instantiateViewControllerWithIdentifier("editTextItem") as! EditTextItemNavigationController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupParentView() -> Bool {
        if let canvas = self.manager.canvas {
            if let view = canvas.view {
                self.parentView = view
                return true
            }
        }
        
        return false
    }
    
    func addText(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute ) {
        let width : CGFloat = UIScreen.mainScreen().bounds.size.width - 20 - location.x
        var height : CGFloat = ((CGFloat(text.length) / width) + 5) * 20
        
        let textItemView = UITextView(frame: CGRectMake(location.x, location.y, width, height))
        self.view = textItemView
        changeText(text, textAttribute: textAttribute)

        textItemView.backgroundColor = UIColor.clearColor()
        textItemView.editable = false
        setupGestureRecognizer()
    }
    
    func changeText(text: String, textAttribute: TextItemOtherAttribute) {
        if let textItemView: UITextView = self.view as! UITextView {
            textItemView.text = text
            textItemView.textColor = textAttribute.colour
            textItemView.font = textAttribute.font
            textItemView.textAlignment = textAttribute.alignment
        }
    }
    
    func setupEditTextItemViewController(text: String, textAttribute: TextItemOtherAttribute) {
        if let editView = self.editView?.topViewController as? EditTextItemViewController {
            print("change editTextItemViewController")
            editView.changeTextAndAttribute(text, textAttribute: textAttribute)
        }
    }
    
    
    func addText(textItem: TextItemEntry) {
        let textItemView = UITextView(frame: textItem.getFrame())
        let text = textItem.getContent()
        let textAttribute = TextItemOtherAttribute(colour: textItem.getTextColour(), font: textItem.getTextFont(), alignment: textItem.getTextAlignment())
        
        self.view = textItemView
        changeText(text, textAttribute: textAttribute)
        setupEditTextItemViewController(text, textAttribute: textAttribute)
        
        textItemView.backgroundColor = UIColor.clearColor()
        textItemView.editable = false
        setupGestureRecognizer()
    }
    
    func setupGestureRecognizer() {
        tapRec.addTarget(self, action: "tappedView")
        pinchRec.addTarget(self, action: "pinchedView:")
        rotateRec.addTarget(self, action: "rotatedView:")
        panRec.addTarget(self, action: "draggedView:")
        
        self.view.addGestureRecognizer(tapRec)
        self.view.addGestureRecognizer(pinchRec)
        self.view.addGestureRecognizer(rotateRec)
        self.view.addGestureRecognizer(panRec)
        
        self.view.userInteractionEnabled = true
        self.view.multipleTouchEnabled = true
    }

    
    func tappedView() {
        print("tapped")
        if let editView = self.editView {
            editView.viewDelegate = self
            self.presentViewController(editView, animated: true, completion: nil)
            if let textView = self.view as? UITextView {
                let textAttribute = TextItemOtherAttribute(colour: textView.textColor!, font: textView.font!, alignment: textView.textAlignment)
                setupEditTextItemViewController(textView.text, textAttribute: textAttribute)
            }
        }
    }
    
    func pinchedView(sender: UIPinchGestureRecognizer) {
        print("pinched")
        self.view.bringSubviewToFront(self.view)
        sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1.0
    }
    
    func rotatedView(sender: UIRotationGestureRecognizer) {
        print("rotate")
        
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
        print("dragged")
        
        if self.parentView == nil {
            setupParentView()
        }
        if let parentView = self.parentView {
            if let senderView = sender.view {
                parentView.bringSubviewToFront(senderView)
                let translation = sender.translationInView(parentView)
                senderView.center = CGPointMake(senderView.center.x + translation.x, senderView.center.y + translation.y)
                sender.setTranslation(CGPointZero, inView: parentView)
                parentView.sendSubviewToBack(senderView)
            }
        }
    }
    
    
    // EditTextItemViewController Delegate functions
    func addText(controller: EditTextItemViewController, text: String, textAttribute: TextItemOtherAttribute) {
        changeText(text, textAttribute: textAttribute)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelAddTextItem(controller: EditTextItemViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
