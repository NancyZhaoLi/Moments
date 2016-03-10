//
//  ItemEntry.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-22.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
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

class TextItemEntry {
    let id: Int64
    private var frame : CGRect
    private var content : String?
    private var rotation : Float = 0
    private var otherAttribute : TextItemOtherAttribute = TextItemOtherAttribute()

    init(id: Int64, frame : CGRect) {
        self.id = id
        self.frame = frame
    }
    
    init(textItemMO: TextItem) {
        self.id = textItemMO.id!.longLongValue
        self.frame = CGRectFromString(textItemMO.frame!)
        self.content = textItemMO.content
        self.rotation = textItemMO.rotation!.floatValue
        
        if let data = textItemMO.otherAttribute as? NSData {
            if let attribute = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? TextItemOtherAttribute  {
                self.otherAttribute = attribute
                print("successfully get the attributes")
            } else {
                print("cannot convert to TextItemOtherAttribute")
            }
        } else {
            print("cannot convert to NSData")
        }
    }
    
  
    func setContent(content: String) {
        self.content = content
    }
  
    func setRotation(rotation : Float) {
        self.rotation = rotation
    }
  
    func setOtherAttribute(colour: UIColor, font: UIFont, alignment: NSTextAlignment) {
        self.otherAttribute.colour = colour
        self.otherAttribute.font = font
        self.otherAttribute.alignment = alignment
    }

    func getFrame() -> CGRect {
        return self.frame
    }
    
    func getContent() -> String {
        if let content = self.content {
            return content
        }
        
        return ""
    }
    
    func getRotation() -> Float {
        return self.rotation
    }
    
    func getTextColour() -> UIColor {
        return self.otherAttribute.colour
    }
    
    func getTextFont() -> UIFont {
        return self.otherAttribute.font
    }
    
    func getTextAlignment() -> NSTextAlignment {
        return self.otherAttribute.alignment
    }
    
    func getOtherAttribute() -> TextItemOtherAttribute {
        return self.otherAttribute
    }
    
}
