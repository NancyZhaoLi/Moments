//
//  ItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-04-07.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import MediaPlayer

class ItemViewController: UIViewController {
    var manager: NewMomentManager?

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init?(manager: NewMomentManager?) {
        super.init(nibName: nil, bundle: nil)
        
        if let manager = manager {
            self.manager = manager
        } else {
            return nil
        }
    }
    
    
    func addItem(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute ) {}
    
    func addItem(image image: UIImage, location: CGPoint){}
    
    func addItem(musicItem music: MPMediaItem, location: CGPoint) {}
    
    func addItem(recordingURL url: NSURL, location: CGPoint) {}
    
    func addItem(videoURL url: NSURL, location: CGPoint) {}
    
    func addItem(stickerName stickerName: String, location: CGPoint) {}
    
    func addItem(text text: TextItem) {}
    
    func addItem(image image: ImageItem) {}
    
    func addItem(audio audio: AudioItem) {}
    
    func addItem(video video: VideoItem) {}
    
    func addItem(sticker sticker: StickerItem) {}
    
    internal func addToCanvas() {
        if let manager = self.manager {
            manager.addItemToCanvas(self)
        }
    }
    
    internal func addToCanvas(zPosition: Int) {
        if let manager = self.manager {
            manager.addItemToCanvas(self, zPosition: zPosition)
        }
    }
    
    internal func addGR() {
        addTrashGR()
        addDragGR()
        addPinchGR()
        addRotateGR()
    }
    
    var trashGR: UITapGestureRecognizer?
    var dragGR: UIPanGestureRecognizer?
    var pinchGR: UIPinchGestureRecognizer?
    var rotateGR: UIRotationGestureRecognizer?
    
    
    func addTrashGR() {
        if let manager = self.manager {
            self.trashGR = manager.trashGR(self)
            self.view.addGestureRecognizer(self.trashGR!)
        }
    }
    
    func addDragGR() {
        if let manager = self.manager {
            self.dragGR =  manager.dragGR()
            self.view.addGestureRecognizer(self.dragGR!)
        }
    }
    
    func addPinchGR() {
        if let manager = self.manager {
            self.pinchGR =  manager.pinchGR()
            self.view.addGestureRecognizer(self.pinchGR!)
        }
    }
    
    func addRotateGR() {
        if let manager = self.manager {
            self.rotateGR =  manager.rotateGR()
            self.view.addGestureRecognizer(self.rotateGR!)
        }
    }
    
    func enableTrash(enabled: Bool) {
        if let trashGR = self.trashGR {
            trashGR.enabled = enabled
        }
    }
    
    func enableViewMode(enabled: Bool) {
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
