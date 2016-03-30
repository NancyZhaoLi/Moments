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
    var parentView: UIView!
    
    var tapToTrashGR: UITapGestureRecognizer?
    
    private let defaultMaxDimension: CGFloat = 130.0
    
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
    
    func addSticker(stickerName: String, location: CGPoint) {
        if let sticker = UIImage(named: stickerName) {
            let stickerMaxDimension: CGFloat = max(sticker.size.height, sticker.size.width)
            var resizeRatio: CGFloat = 1.0
            
            if stickerMaxDimension > defaultMaxDimension {
                resizeRatio = stickerMaxDimension/defaultMaxDimension
            }
            
            let frame = CGRectMake(0,0, sticker.size.width/resizeRatio, sticker.size.height/resizeRatio)
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

