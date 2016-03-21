//
//  NewItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-17.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Darwin

protocol NewItemViewControllerDelegate {
    func addText()
    func addImageFromGallery()
    func addImageFromCamera()
    func addSticker()
    func addAudioFromRecorder()
    func addAudioFromMusic()
    func addVideoFromCamera()
    func addVideoFromYoutube()
}

struct ItemType {
    var name: String
    var image: UIImage
    var action: Selector
    
    static private let moreItemsIndex = 8
    static private let goBackIndex = 9
    static private let dismissIndex = 10
    static let itemTypes:[ItemType] = [
        ItemType(name: "text", image: UIImage(named: "text_icon.png")!, action: "addText"),
        ItemType(name: "imageFromCamera", image: UIImage(named: "camera_icon.png")!, action: "addImageFromCamera"),
        ItemType(name: "imageFromGallery", image: UIImage(named: "gallery_icon.png")!, action: "addImageFromGallery"),
        ItemType(name: "sticker", image: UIImage(named: "sticker_icon.png")!, action: "addSticker"),
        ItemType(name: "audioFromRecorder", image: UIImage(named: "recorder_icon.png")!, action: "addAudioFromRecorder"),
        ItemType(name: "audioFromMusic", image: UIImage(named: "music_icon.png")!, action: "addAudioFromMusic"),
        ItemType(name: "videoFromCamera", image: UIImage(named: "video_icon.png")!, action: "addVideoFromCamera"),
        ItemType(name: "videoFromYoutube", image: UIImage(named: "youtube.png")!, action: "addVideoFromYoutube"),
        ItemType(name: "moreItems", image: UIImage(named: "more_icon.png")!, action: "loadMoreItems"),
        ItemType(name: "goBack", image: UIImage(named: "exit_icon.png")!, action: "goBack"),
        ItemType(name: "dismiss", image: UIImage(named: "exit_icon.png")!, action: "dismiss")
    ]
    
    init(name: String, image: UIImage, action: Selector){
        self.name = name
        self.image = UIHelper.resizeImage(image,newWidth: 80.0)
        self.action = action
    }
    

    
    static func goBack() -> ItemType{
        return ItemType.itemTypes[ItemType.goBackIndex]
    }
    
    static func dismiss() -> ItemType {
        return ItemType.itemTypes[ItemType.dismissIndex]
    }
    
    static func moreItems() -> ItemType {
        return ItemType.itemTypes[ItemType.moreItemsIndex]
    }

    static func getType(index: Int) -> ItemType {
        if index > 7 {
            return goBack()
        }
        
        return ItemType.itemTypes[index]
    }
}


class NewItemViewController: UIViewController,
    UIViewControllerTransitioningDelegate {

    var delegate: NewItemViewControllerDelegate?
    var rootView: UIView!
    var moreItemsView: UIView!
    
    var userShortcut: [Int]! = [0, 1, 2, 3, 4, 5 , 6]
    var moreItems: [Int]! = []
    var width = windowWidth - 20
    var height = windowHeight - 20
    
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
        rootView = UIView(frame: CGRectMake(0,0,width, height))
        initRootView()
        
        moreItemsView = UIView(frame: CGRectMake(0,0,width, height))
        initMoreItemsView()
        
        self.view = rootView
        self.preferredContentSize = self.view.frame.size
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    func initRootView() {
        addDismissButton(rootView)
        
        let total = userShortcut.count
        for var count = 0; count < total; count++ {
            let itemType = ItemType.getType(userShortcut[count])
            let center = calCenter(count, total: total)
            rootView.addSubview(newButton(itemType, center: center))
        }
        
        //addMoreItemsButton(rootView)
    }
    
    func initMoreItemsView() {
        addGoBackButton(moreItemsView)
        
        let total = moreItems.count
        for var count = 0; count < total; count++ {
            let itemType = ItemType.getType(moreItems[count])
            let center = calCenter(count, total: total)
            moreItemsView.addSubview(newButton(itemType, center: center))
        }
    }
    
    func initAnimation(sourceView: UIView?) {
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
    }
    
    
    // Button Target Functions
    func goBack() {
        self.view = rootView
    }
    
    func dismiss() {
        self.view = rootView
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadMoreItems() {
        self.view = moreItemsView
    }
    
    func addText() {
        self.dismiss()
        self.delegate?.addText()
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

    func addAudioFromRecorder() {
        self.dismiss()
        self.delegate?.addAudioFromRecorder()
    }
    
    func addAudioFromMusic() {
        self.dismiss()
        self.delegate?.addAudioFromMusic()
    }
    
    func addVideoFromCamera() {
        self.dismiss()
        self.delegate?.addVideoFromCamera()
    }
    
    func addVideoFromYoutube() {
        self.dismiss()
        self.delegate?.addVideoFromYoutube()
    }


    // Private Init Helper Functions
    func newButton(item: ItemType, center: CGPoint) -> UIButton {
        let button = UIButton(frame: CGRectMake(0,0,60,60))
        button.center = center
        button.setImage(item.image, forState: .Normal)
        button.addTarget(self, action: item.action, forControlEvents: .TouchUpInside)
        
        return button
    }
    
    private func addGoBackButton(view: UIView) {
        let goBackButton = newButton(ItemType.goBack(), center: CGPointMake(width/2.0, height/2.0))
        view.addSubview(goBackButton)
    }
    
    private func addDismissButton(view: UIView) {
        let goBackToRootViewButton = newButton(ItemType.dismiss(), center: CGPointMake(width/2.0, height/2.0))
        view.addSubview(goBackToRootViewButton)
    }
    
    private func addMoreItemsButton(view: UIView) {
        let moreItems = ItemType.moreItems()
        let moreItemsButton = newButton(moreItems, center: calCenter(userShortcut.count, total: userShortcut.count + 1))
        view.addSubview(moreItemsButton)
    }
    
    private func calCenter(index: Int, total: Int) -> CGPoint {
        let center = CGPointMake(width/2.0, height/2.0)
        let radius: CGFloat = 120.0
        let radian: CGFloat = (360.0 - (360.0/CGFloat(total) * CGFloat(index)) - 90.0) * CGFloat(M_PI) / 180.0

        let newX: CGFloat = radius * cos(radian) + center.x
        let newY: CGFloat = radius * sin(radian) + center.y
        
        return CGPointMake(newX, newY)
    }
    
    
    // Animation
    func presentationControllerForPresentedViewController(presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController) -> UIPresentationController? {
            
            return CategoryPresentationController(presentedViewController: presented,
                presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController)-> UIViewControllerAnimatedTransitioning? {
        return CategoryPresentationAnimationController()
    }

}
