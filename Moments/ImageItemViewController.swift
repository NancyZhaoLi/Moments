//
//  ImageItemViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-20.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class ImageItemView: UIImageView {
    var lastLocation:CGPoint = CGPointMake(0,0)
    var url : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(ßcoder aDecoder: NSCoder) {
        print("got")
        super.init(coder: aDecoder)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

class ImageItemViewController: UIViewController {
    
    var manager: ImageItemManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(manager: nil)
    }
    
    init(manager: ImageItemManager?) {
        super.init(nibName: nil, bundle: nil)
        self.manager = manager
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImage(image: UIImage, location: CGPoint, editingInfo: [String : AnyObject]?) {
        
        let imageSize: CGFloat = 200.0
        let frame = CGRectMake(location.x, location.y, imageSize, imageSize)
        let imageView = ImageItemView(frame: frame)
        
        imageView.image = image
        if let editInfo = editingInfo {
            if let url = editInfo[UIImagePickerControllerReferenceURL] as? NSURL {
                imageView.url = url.absoluteString
            }
        }
        self.view = imageView
    }
}

class ImageItemManager : ItemManager {
    
    private var imageItems : [ImageItemViewController] = [ImageItemViewController]()
    
    override init() {
        super.init()
        super.type = ItemType.Image
        super.debugPrefix = "[ImageItemManager] - "
    }

    func deleteImage(deletedImageVC: ImageItemViewController) {
        
    }
    
    func addImage(image: UIImage, location: CGPoint, editingInfo: [String : AnyObject]?) {
        var newImageVC = ImageItemViewController(manager: self)
        newImageVC.addImage(image, location: location, editingInfo: editingInfo)
            
        self.imageItems.append(newImageVC)
        super.canvas!.view.addSubview(newImageVC.view)
        super.canvas!.addChildViewController(newImageVC)
    }
    
    override func saveAllItemEntry() {
        debugBegin("saveAllItemEntry")
        var id = getId()
        
        for imageItem in imageItems {
            let view = imageItem.view as! ImageItemView
            var imageItemEntry = ImageItemEntry(id: id, frame: view.frame)
            imageItemEntry.setContent(view.url!)
            
            self.superManager!.addImageItemEntry(imageItemEntry)
            id += 1
        }
        
        debug("[saveAllItemEntry] - max image id: " + String(id))
        debugEnd("saveAllItemEntry")
    }
}







