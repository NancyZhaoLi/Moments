//
//  CameraOverlayView.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-27.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class CameraOverlayViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var albumButton: UIButton!
    var delegate: UIImagePickerControllerDelegate?
    var cameraPicker: UIImagePickerController?
    
    init(frame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = nil
        self.albumButton = UIButton(frame: CGRectMake(0,0,70,40))
        self.albumButton.center = CGPointMake(frame.size.width - 50.0, frame.size.height - 50.0)
        self.albumButton.backgroundColor = UIColor.clearColor()
        self.albumButton.setTitle("Album", forState: .Normal)
        self.albumButton.tintColor = UIColor.whiteColor()
        self.view = UIView(frame: frame)
        self.view.addSubview(albumButton)
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectMake(0,0,0,0))
    }
    
    
    func initDelegate(delegate: UIImagePickerControllerDelegate) {
        self.delegate = delegate
        self.albumButton.addTarget(self, action: "selectFromAlbum", forControlEvents: .TouchUpInside)
    }
    
    func selectFromAlbum() {
        var sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        if !UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
            sourceType = .PhotoLibrary
        }
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = sourceType
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(false)
        if let delegate = self.delegate, cameraPicker = self.cameraPicker {
            delegate.imagePickerController!(cameraPicker, didFinishPickingMediaWithInfo: editingInfo!)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismiss(true)
        if let delegate = self.delegate, cameraPicker = self.cameraPicker {
            delegate.imagePickerControllerDidCancel!(cameraPicker)
        }
    }
    
    
}
