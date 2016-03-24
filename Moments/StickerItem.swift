//
//  StickerItem.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class StickerItem: NSManagedObject {
    
    internal var image: UIImage?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        self.image = UIImage(named: self.name)
    }
    
    init?(frame: CGRect, name: String, zPosition: Int) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("TextItem", inManagedObjectContext: context)
        
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: nil)
            setItemFrame(frame)
            setItemName(name)
            setItemZPosition(zPosition)
        } else {
            super.init()
            print("ERROR: entity not found for TextItem")
            return nil
        }
    }
    
    func getFrame() -> CGRect {
        return CGRectFromString(self.frame)
    }
    
    func setItemFrame(frame: CGRect) {
        self.frame = NSStringFromCGRect(frame)
    }
    
    func getImage() -> UIImage? {
        return self.image
    }
    
    func getName() -> String {
        return self.name
    }
    func setItemName(name: String) {
        self.name = name
        self.image = UIImage(named: name)
    }
    
    func getZPosition() -> Int {
        return self.zPosition.integerValue
    }
    
    func setItemZPosition(zPosition: Int) {
        self.zPosition = NSNumber(integer: zPosition)
    }
    
}
