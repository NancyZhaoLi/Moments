//
//  StickerItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class StickerItemView: UIImageView {
    var stickerName: String?
}

class StickerItemViewController: UIViewController, NewMomentItemGestureDelegate {
    var manager: NewMomentManager?
    
    convenience init() {
        self.init(manager: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(manager: NewMomentManager?) {
        super.init(nibName: nil, bundle: nil)
        
        self.manager = manager
    }
    
    func addSticker(stickerName: String, location: CGPoint) {
        let defaultMaxDimension: CGFloat = 130.0
        if let sticker = UIImage(named: stickerName) {
            // Calculate sticker size
            let stickerMaxDimension: CGFloat = max(sticker.size.height, sticker.size.width)
            var resizeRatio: CGFloat = 1.0
            if stickerMaxDimension > defaultMaxDimension {
                resizeRatio = stickerMaxDimension/defaultMaxDimension
            }
            let newWidth = sticker.size.width/resizeRatio
            let newHeight = sticker.size.height/resizeRatio
            
            // Add the sticker
            let frame = CGRectMake(0,0, newWidth, newHeight)
            let stickerView = StickerItemView(frame: frame)
            stickerView.center = location
            stickerView.stickerName = stickerName
            stickerView.image = sticker
            self.view = stickerView
        } else {
            print("cannot add sticker with name: \(stickerName)")
        }
    }

    func addSticker(stickerItem: StickerItem) {
        if let image = stickerItem.getImage() {
            let stickerView = StickerItemView(frame: stickerItem.getFrame())
            stickerView.stickerName = stickerItem.getName()
            stickerView.image = image
            self.view = stickerView
        }
    }
    
    /*********************************************************************************
     
     GESTURE RECOGNIZERS
     
     *********************************************************************************/
    var trashGR: UITapGestureRecognizer?
    var dragGR: UIPanGestureRecognizer?
    var pinchGR: UIPinchGestureRecognizer?
    
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
    }
    
    func enableTrash(enabled: Bool) {
        if let trashGR = self.trashGR {
            trashGR.enabled = enabled
        }
    }
    
    func enableViewMode(enabled: Bool) {
        dragGR?.enabled = !enabled
        pinchGR?.enabled = !enabled
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

