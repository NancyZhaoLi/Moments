//
//  StickerItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class StickerItemViewController: UIViewController {
    
    var manager: NewMomentManager?
    var parentView: UIView!
    
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
            fatalError("ERROR: [TextItemViewController] parentView init failed")
        }
    }
    
    private func initParentView() -> Bool {
        if let canvas = manager!.canvasVC, view = canvas.view {
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
    
    func initGestureRecognizer() {
        pinchRec.addTarget(self, action: "pinchedView:")
        rotateRec.addTarget(self, action: "rotatedView:")
        
        self.view.addGestureRecognizer(pinchRec)
        self.view.addGestureRecognizer(rotateRec)
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
    
    /*********************************************************************************
    
    DELEGATE FUNCTIONS
    
    *********************************************************************************/

}

