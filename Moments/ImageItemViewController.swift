//
//  ImageItemViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-20.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class ImageItemViewController: UIImageView {
    var lastLocation:CGPoint = CGPointMake(0,0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let touchRecognizer = UIPanGestureRecognizer(target:self, action: "detectTouch:")
        //self.gestureRecognizers = [touchRecognizer]
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("got")
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("start")
        self.superview?.bringSubviewToFront(self)
        lastLocation = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("moved")
    }
    func detectTouch(recognizer:UIPanGestureRecognizer){
        print("detect")
        let translation = recognizer.translationInView(self.superview!)
        self.center = CGPointMake(lastLocation.x + translation.x, lastLocation.y + translation.y)
    }
}
