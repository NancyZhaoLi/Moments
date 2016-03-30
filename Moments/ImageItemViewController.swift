//
//  ImageItemViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-20.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class ImageItemView: UIImageView {
    var url: NSURL = NSURL()
    var rotation: CGFloat = 0.0
}


class ImageItemViewController: UIViewController, NewMomentItemGestureDelegate {
    
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
            fatalError("ERROR: [ImageItemViewController] parentView init failed")
        }
    }

    func initParentView() -> Bool {
        if let canvas = manager!.canvasVC, view = canvas.view {
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
        
        let frame = CGRectMake(0,0, image.size.width/resizeRatio, image.size.height/resizeRatio)
        let imageView = ImageItemView(frame: frame)
        
        imageView.center = location
        imageView.image = image
        
        self.view = imageView
    }
    
    func addImage(imageItem: ImageItem) {
        let imageView =  ImageItemView(frame: imageItem.getFrame())
        imageView.image = imageItem.getImage()
        imageView.layer.zPosition = CGFloat(imageItem.getZPosition())
        //rotate(imageView, rotation: imageView.rotation)
        
        imageView.rotation = CGFloat(imageItem.getRotation())
        let currentTransform = imageView.transform
        let newTransform = CGAffineTransformRotate(currentTransform, imageView.rotation)
        imageView.transform = newTransform
        
        self.view = imageView
    }
    
    private func rotate(view: ImageItemView, rotation: CGFloat){

        
        print("rotate: \(view.rotation)")
    }
    
    var trashGR: UITapGestureRecognizer?
    var dragGR: UIPanGestureRecognizer?
    var pinchGR: UIPinchGestureRecognizer?
    var rotateGR: UIRotationGestureRecognizer?
    
    func addTrashGR(trashGR: UITapGestureRecognizer) {
        self.trashGR = trashGR
        self.view.addGestureRecognizer(trashGR)
    }
    
    func addDragGR(dragGR: UIPanGestureRecognizer) {
        self.dragGR = dragGR
        self.view.addGestureRecognizer(dragGR)
    }
    
    func addPinchGR(pinchGR: UIPinchGestureRecognizer) {
        self.pinchGR = pinchGR
        self.view.addGestureRecognizer(pinchGR)
    }
    
    func addRotateGR(rotateGR: UIRotationGestureRecognizer) {
        self.rotateGR = rotateGR
        self.view.addGestureRecognizer(rotateGR)
    }
    
    func enableTrash(enabled: Bool) {
        if let trashGR = self.trashGR {
            trashGR.enabled = enabled
        }
    }
    
    func enableViewMode(enabled: Bool) {
        trashGR?.enabled = !enabled
        dragGR?.enabled = !enabled
        pinchGR?.enabled = !enabled
        rotateGR?.enabled = !enabled
    }
    
    func tapToTrash(sender: UITapGestureRecognizer) {
        if let senderView = sender.view {
            if sender.numberOfTouches() != 1 {
                return
            }
            senderView.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
}

