//
//  NewItemPopoverViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-17.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

protocol NewItemViewControllerDelegate {
    func addText()
    func addImageFromGallery()
    func addImageFromCamera()
    func addSticker()
}


class NewImageView: UIView {
    
    var back: UIButton!
    var camera: UIButton!
    var gallery: UIButton!
    var sticker: UIButton!
    var viewController: NewItemViewController!
    
    convenience init() {
        self.init(frame: CGRectMake(0,0,windowWidth, windowHeight), viewController: NewItemViewController())
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(frame: CGRect, viewController: NewItemViewController) {
        super.init(frame: frame)
        self.viewController = viewController
        
        initView()
        initButton()
    }
    
    func initView() {
        self.center = CGPointMake(windowWidth/2.0, windowHeight/2.0)
        self.bounds = self.frame
    }
    
    func initButton() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let backImage = UIImage(named: "text.png")
        let cameraImage = UIImage(named: "text.png")
        let galleryImage = UIImage(named: "text.png")
        let stickerImage = UIImage(named: "text.png")
        
        back = viewController.newButton(backImage, center: CGPointMake(width/2.0, height/2.0), actionName: "goBack")
        camera = viewController.newButton(cameraImage, center: CGPointMake(width/2.0, height/2.0 - 60), actionName: "addImageFromCamera")
        gallery = viewController.newButton(galleryImage, center: CGPointMake(width/2.0 - 60, height/2.0 + 60), actionName: "addImageFromGallery")
        sticker = viewController.newButton(stickerImage, center: CGPointMake(width/2.0 + 60, height/2.0 + 60), actionName: "addSticker")
        
        self.addSubview(back)
        self.addSubview(camera)
        self.addSubview(gallery)
        self.addSubview(sticker)
    }
}

class NewItemView: UIView {
    
    var back: UIButton!
    var text: UIButton!
    var image: UIButton!
    var audio: UIButton!
    var video: UIButton!
    var viewController: NewItemViewController!
    
    convenience init() {
        self.init(frame: CGRectMake(0,0,windowWidth, windowHeight), viewController: NewItemViewController())
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(frame: CGRect, viewController: NewItemViewController) {
        super.init(frame: frame)
        self.viewController = viewController
        
        initView()
        initButton()
    }
    
    func initView() {
        self.center = CGPointMake(windowWidth/2.0, windowHeight/2.0)
        self.bounds = self.frame
        self.backgroundColor = UIColor.whiteColor()
    }
    
    func initButton() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        let backImage = UIImage(named: "text.png")
        let textImage = UIImage(named: "text.png")
        let imageImage = UIImage(named: "text.png")
        let audioImage = UIImage(named: "text.png")
        let videoImage = UIImage(named: "text.png")
        
        back = viewController.newButton(backImage, center: CGPointMake(width/2.0, height/2.0), actionName: "goBack")
        text = viewController.newButton(textImage, center: CGPointMake(width/2.0 - 60, height/2.0 - 60), actionName: "addText")
        image = viewController.newButton(imageImage, center: CGPointMake(width/2.0 + 60, height/2.0 - 60), actionName: "goToImageView")
        audio = viewController.newButton(audioImage, center: CGPointMake(width/2.0 - 60, height/2.0 + 60), actionName: "goToAudioView")
        video = viewController.newButton(videoImage, center: CGPointMake(width/2.0 + 60, height/2.0 + 60), actionName: "goToVideoView")
        
        self.addSubview(back)
        self.addSubview(text)
        self.addSubview(image)
        self.addSubview(audio)
        self.addSubview(video)
    }
}




class NewItemViewController: UIViewController,
    UIViewControllerTransitioningDelegate {

    var delegate: NewItemViewControllerDelegate?
    var views: [UIView]! = [UIView]()
    var rootView: NewItemView!
    var imageView: NewImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(sourceView: nil, delegate: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(sourceView: UIView?, delegate: NewItemViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        
        initView()
        initAnimation(sourceView)
    }


    func initView() {
        self.view = NewItemView(frame: CGRectMake(0,0,windowWidth-20, windowHeight-20), viewController: self)
        self.views.append(self.view)
        self.preferredContentSize = self.view.frame.size
        self.view.backgroundColor = UIColor.clearColor()
        
        self.imageView = NewImageView(frame: self.view.frame, viewController: self)
    }
    
    func initAnimation(sourceView: UIView?) {
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController) -> UIPresentationController? {
            
            return CategoryPresentationController(presentedViewController: presented,
                presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController)-> UIViewControllerAnimatedTransitioning? {
        return CategoryPresentationAnimationController()
    }

    func newButton(image: UIImage?, center: CGPoint, actionName: Selector) -> UIButton {
        let button = UIButton(frame: CGRectMake(0,0,50,50))
        button.center = center
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: actionName, forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func goBack() {
        if self.views.count == 1 {
            dismiss()
        } else {
            self.view = rootView as UIView
        }
    }
    
    func addText() {
        //self.dismiss()
        self.delegate?.addText()
    }
    
    func goToImageView() {
        self.view = imageView
    }
    
    func addImageFromCamera() {
        self.dismiss()
        self.delegate?.addImageFromCamera()
    }
    
    func addImageFromGallery() {
        self.dismiss()
        self.delegate?.addImageFromGallery()
    }
    
    func addSticker() {
        self.dismiss()
        self.delegate?.addSticker()
    }
    
    func goToAudioView() {
        print("add audio")
    }
    
    func goToVideoView() {
        print("add video")
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
           //print(touch.locationInView(self.view))
        }
    }

}
