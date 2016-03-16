//
//  ImageItemViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-20.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class ImageItemViewController: UIViewController {
    
    var manager: ImageItemManager!
    var parentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(manager: ImageItemManager())
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(manager: ImageItemManager) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
        if !initParentView() {
            fatalError("ERROR: [ImageItemViewController] parentView init failed")
        }
    }

    func initParentView() -> Bool {
        if let canvas = self.manager.canvas, view = canvas.view {
            self.parentView = view
            return true
        }
        return false
    }
    
    func addImage(image: UIImage, location: CGPoint, editingInfo: [String : AnyObject]?) {
        let defaultMaxDimension: CGFloat = 200.0
        let imageMaxDimension:CGFloat = max(image.size.height, image.size.width)
        var resizeRatio: CGFloat = 1.0

        if imageMaxDimension > defaultMaxDimension {
            resizeRatio = imageMaxDimension/defaultMaxDimension
        }
        
        let frame = CGRectMake(location.x, location.y, image.size.width/resizeRatio, image.size.height/resizeRatio)
        let imageView = UIImageView(frame: frame)
        
        imageView.image = image
        self.view = imageView
        initGestureRecognizer()
    }
    
    func addImage(imageItem: ImageItemEntry) {
        let imageView =  UIImageView(frame: imageItem.frame)
        imageView.image = imageItem.image
        self.view = imageView
        initGestureRecognizer()
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
        print("pinched")
        parentView.bringSubviewToFront(self.view)
        sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 0.5
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
    
}

