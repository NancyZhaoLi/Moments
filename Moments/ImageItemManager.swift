//
//  ImageItemManager.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-09.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class ImageItemManager : ItemManager {
    
    private var imageItems : [ImageItemViewController] = [ImageItemViewController]()
    
    override init() {
        super.init()
        super.type = ItemType.Image
        super.debugPrefix = "[ImageItemManager] - "
    }
    
    func deleteImage(deletedImageVC: ImageItemViewController) {
        
    }
    
    func addImage(image: UIImage, location: CGPoint, editingInfo: [String : AnyObject]?) -> ImageItemViewController {
        debug("[addImage] - url: " + String(editingInfo![UIImagePickerControllerReferenceURL]))
        var newImageVC = ImageItemViewController(manager: self)
        newImageVC.addImage(image, location: location, editingInfo: editingInfo)
        
        self.imageItems.append(newImageVC)
        return newImageVC
    }
    
    func loadImage(imageItem: ImageItemEntry) -> ImageItemViewController {
        var newImageVC = ImageItemViewController(manager: self)
        
        newImageVC.addImage(imageItem)
        self.imageItems.append(newImageVC)
        return newImageVC
    }
    
    override func saveAllItemEntry() {
        var id = getId()
        
        for imageItem in imageItems {
            let view = imageItem.view as! ImageItemView
            let imageItemEntry = ImageItemEntry(id: id, frame: view.frame, image: view.image!)
            //imageItemEntry.setURL(view.url!)
            
            self.superManager!.addImageItemEntry(imageItemEntry)
            id += 1
        }
    }
}