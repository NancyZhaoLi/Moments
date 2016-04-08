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

class StickerItemViewController: ItemViewController {

    override func addItem(stickerName stickerName: String, location: CGPoint) {
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
            
            addToCanvas()
            addGR()
        } else {
            print("cannot add sticker with name: \(stickerName)")
        }
    }

    override func addItem(sticker sticker: StickerItem) {
        if let image = sticker.getImage() {
            let stickerView = StickerItemView(frame: sticker.getFrame())
            stickerView.stickerName = sticker.getName()
            stickerView.image = image
            self.view = stickerView
            
            addToCanvas(sticker.getZPosition())
            addGR()
        }
    }
    
    override func tapToTrash(sender: UITapGestureRecognizer) {
        super.tapToTrash(sender)
    }
}

