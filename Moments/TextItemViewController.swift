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

    var manager: NewMomentManager!
    var parentView: UIView!
    var editViewNavController: EditTextItemNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(manager: NewMomentManager())
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(manager: NewMomentManager) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
        if !initParentView() {
            fatalError("ERROR: [TextItemViewController] parentView init failed")
        }
        
        initEditView()
    }
    
    func initParentView() -> Bool {
        if let canvas = self.manager.canvas, view = canvas.view {
            self.parentView = view
            return true
        }
        return false
    }
    
    func initEditView() {
        self.editViewNavController = EditTextItemNavigationController(viewDelegate: self, text: nil, textAttribute: nil)
    }
    
    func addText(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute ) {
        let width : CGFloat = UIScreen.mainScreen().bounds.size.width - 20 - location.x
        let height : CGFloat = ((CGFloat(text.length) / width) + 5) * 20
        
        let textItemView = UITextView(frame: CGRectMake(0,0, width, height))
        textItemView.center = location
        
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
        self.presentViewController(editViewNavController, animated: true, completion: nil)
        if let textView = self.view as? UITextView {
            let textAttribute = TextItemOtherAttribute(colour: textView.textColor!, font: textView.font!, alignment: textView.textAlignment)
            initEditTextItemViewController(textView.text, textAttribute: textAttribute)
        }
    }
    
    func pinchedView(sender: UIPinchGestureRecognizer) {
        parentView.bringSubviewToFront(self.view)
        sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale * 0.5, sender.scale * 0.5)
        sender.scale = 1.0
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
            var translation = sender.translationInView(parentView)
            if senderView.frame.minY + translation.y <= 60 {
                translation.y = 60 - senderView.frame.minY
            }
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
