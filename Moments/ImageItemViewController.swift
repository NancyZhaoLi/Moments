//
//  ImageItemViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-20.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class ImageItemView: UIImageView {
    var lastLocation:CGPoint = CGPointMake(0,0)
    var url : NSURL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(ßcoder aDecoder: NSCoder) {
        print("got")
        super.init(coder: aDecoder)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
}

class ImageItemViewController: UIViewController {
    
    var manager: ImageItemManager!
    var parentView: UIView?
    
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
    
    init(manager: ImageItemManager) {
        super.init(nibName: nil, bundle: nil)
        self.manager = manager
        if setupParentView() {
            print("parentView setup successful in initializing imageItemViewController")
        } else {
            print("parentView setup failed in initializing imageItemViewController")
        }
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
    
    func addImage(image: UIImage, location: CGPoint, editingInfo: [String : AnyObject]?) {
        let imageSize: CGFloat = 200.0
        let frame = CGRectMake(location.x, location.y, imageSize, imageSize)
        let imageView = ImageItemView(frame: frame)
        
        imageView.image = image
        if let editInfo = editingInfo {
            if let url = editInfo[UIImagePickerControllerReferenceURL] as? NSURL {
                imageView.url = url
            }
        }
        self.view = imageView
        setupGestureRecognizer()
    }
    
    func addImage(imageItem: ImageItemEntry) {
        let imageView = ImageItemView(frame: imageItem.frame)
        imageView.image = imageItem.image
        self.view = imageView
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
}

