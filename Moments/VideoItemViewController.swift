//
//  VideoItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class VideoItemViewController: UIViewController {

    var manager: NewMomentManager!
    var parentView: UIView!
    
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
            fatalError("ERROR: [AudioItemViewController] parentView init failed")
        }
    }
    
    func initParentView() -> Bool {
        if let canvas = self.manager.canvas, view = canvas.view {
            self.parentView = view
            return true
        }
        return false
    }

    
    func addAudio(audioItem: AudioItemEntry) {
        
    }
    
    /*********************************************************************************
     
     GESTURE RECOGNIZERS
     
     *********************************************************************************/

    let pinchRec: UIPinchGestureRecognizer = UIPinchGestureRecognizer()
    let panRec: UIPanGestureRecognizer = UIPanGestureRecognizer()
    
    func initGestureRecognizer() {
        pinchRec.addTarget(self, action: "pinchedView:")
        panRec.addTarget(self, action: "draggedView:")
        
        self.view.addGestureRecognizer(pinchRec)
        self.view.addGestureRecognizer(panRec)
        
        self.view.userInteractionEnabled = false
        self.view.multipleTouchEnabled = true
    }
    
    
    func pinchedView(sender: UIPinchGestureRecognizer) {
        parentView.bringSubviewToFront(self.view)
        sender.view?.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1.0
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

}
