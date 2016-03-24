//
//  TextItem.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TextItemOtherAttribute: NSObject, NSCoding {
    var colour : UIColor
    var font : UIFont
    var alignment : NSTextAlignment
    
    override init() {
        self.colour = UIColor.blackColor()
        self.font = UIFont(name: "Helvetica Neue", size: 20.0)!
        self.alignment = .Left
        
        super.init()
    }
    
    init(colour: UIColor, font: UIFont, alignment: NSTextAlignment) {
        self.colour = colour
        self.font = font
        self.alignment = alignment
        
        super.init()
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard
            let colour = aDecoder.decodeObjectForKey("colour") as? UIColor,
            let font = aDecoder.decodeObjectForKey("font") as? UIFont,
            let intAlignment = aDecoder.decodeObjectForKey("alignment") as? Int
            else {
                print("nothing")
                return nil
        }
        
        let alignment : NSTextAlignment = NSTextAlignment(rawValue: intAlignment)!
        self.init(colour: colour, font: font, alignment: alignment)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.colour, forKey: "colour")
        aCoder.encodeObject(self.font, forKey: "font")
        aCoder.encodeObject(self.alignment.rawValue, forKey: "alignment")
    }
    
}

class TextItem: NSManagedObject {
    
    var textAttribute: TextItemOtherAttribute?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        if let data = self.otherAttribute as? NSData {
            if let attribute = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? TextItemOtherAttribute {
                self.textAttribute = attribute
            }
        }
    }
    
    init?(content: String, frame : CGRect, otherAttribute: TextItemOtherAttribute, rotation: Float, zPosition: Int) {
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        let entity = NSEntityDescription.entityForName("TextItem", inManagedObjectContext: context)
        
       
        if let entity = entity {
            super.init(entity: entity, insertIntoManagedObjectContext: context)
            setItemContent(content)
            setItemFrame(frame)
            setItemOtherAttribute(otherAttribute)
            setItemRotation(rotation)
            setItemZPosition(zPosition)
        } else {
            super.init()
            print("ERROR: entity not found for textItem")
            return nil
        }
    }
    
    func getContent() -> String {
        return self.content
    }
    
    func getFrame() -> CGRect {
        return CGRectFromString(self.frame)
    }
    
    func getOtherAttribute() -> TextItemOtherAttribute? {
        return self.textAttribute
    }
    
    func getRotation() -> Float {
        return self.rotation.floatValue
    }
    
    func getZPosition() -> Int {
        return self.zPosition.integerValue
    }
    
    func getTextColour() -> UIColor? {
        return self.textAttribute?.colour
    }
    
    func getTextFont() -> UIFont? {
        return self.textAttribute?.font
    }
    
    func getTextAlignment() -> NSTextAlignment? {
        return self.textAttribute?.alignment
    }
    
    func setItemContent(content: String) {
        self.content = content
    }
    
    func setItemFrame(frame: CGRect) {
        self.frame = NSStringFromCGRect(frame)
    }
    
    func setItemOtherAttribute(otherAttribute: TextItemOtherAttribute) {
        self.otherAttribute = NSKeyedArchiver.archivedDataWithRootObject(otherAttribute)
        self.textAttribute = otherAttribute
    }	
    
    func setItemRotation(rotation: Float) {
        self.rotation = NSNumber(float: rotation)
    }
    
    func setItemZPosition(zPosition: Int) {
        self.zPosition = NSNumber(integer: zPosition)
    }
}
