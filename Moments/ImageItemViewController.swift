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


class ImageItemViewController: ItemViewController {
    
    override func addItem(image image: UIImage, location: CGPoint) {
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
        super.addToCanvas()
        super.addGR()
    }
    
    override func addItem(image image: ImageItem) {
        let imageView =  ImageItemView(frame: image.getFrame())
        imageView.image = image.getImage()
        imageView.layer.zPosition = CGFloat(image.getZPosition())
        
        imageView.rotation = CGFloat(image.getRotation())
        let currentTransform = imageView.transform
        let newTransform = CGAffineTransformRotate(currentTransform, imageView.rotation)
        imageView.transform = newTransform
        
        self.view = imageView
        super.addToCanvas(image.getZPosition())
        super.addGR()
    }
    
    override func tapToTrash(sender: UITapGestureRecognizer) {
        super.tapToTrash(sender)
    }

}

