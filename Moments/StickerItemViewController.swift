//
//  StickerItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class StickerItemViewController: UIViewController {
    
    var manager: StickerItemManager!
    var parentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(manager: StickerItemManager())
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(manager: StickerItemManager) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
        if !initParentView() {
            fatalError("ERROR: [TextItemViewController] parentView init failed")
        }
    }
    
    func initParentView() -> Bool {
        if let canvas = self.manager.canvas, view = canvas.view {
            self.parentView = view
            return true
        }
        return false
    }

    func addSticker(stickerItem: StickerItemEntry) {
        
    }
    /*********************************************************************************
     
     GESTURE RECOGNIZERS
     
     *********************************************************************************/
    
    let pinchRec: UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    let rotateRec: UIRotationGestureRecognizer = UIRotationGestureRecognizer()
    let panRec: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    func initGestureRecognizer() {
        pinchRec.addTarget(self, action: "pinchedView:")
        rotateRec.addTarget(self, action: "rotatedView:")
        panRec.addTarget(self, action: "draggedView:")
        
        self.view.addGestureRecognizer(pinchRec)
        self.view.addGestureRecognizer(rotateRec)
        self.view.addGestureRecognizer(panRec)
        
        self.view.userInteractionEnabled = false
        self.view.multipleTouchEnabled = true
    }
    
    func pinchedView(sender: UIPinchGestureRecognizer) {
        parentView.bringSubviewToFront(self.view)
        sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
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
            let translation = sender.translationInView(parentView)
            senderView.center = CGPointMake(senderView.center.x + translation.x, senderView.center.y + translation.y)
            sender.setTranslation(CGPointZero, inView: parentView)
            parentView.sendSubviewToBack(senderView)
        }
    }
    
    /*********************************************************************************
    
    DELEGATE FUNCTIONS
    
    *********************************************************************************/

}

