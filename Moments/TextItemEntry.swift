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

class TextItemEntry {
    let content : String!
    let frame : CGRect!
    var otherAttribute : TextItemOtherAttribute!
    let rotation : Float!
    let zPosition: Int!

    init(content: String, frame : CGRect, otherAttribute: TextItemOtherAttribute, rotation: Float, zPosition: Int) {
        self.content = content
        self.frame = frame
        self.otherAttribute = otherAttribute
        self.rotation = rotation
        self.zPosition = zPosition
    }
    
    init(textItemMO: TextItem) {
        self.content = textItemMO.content
        self.frame = CGRectFromString(textItemMO.frame!)
        self.rotation = textItemMO.rotation!.floatValue
        self.otherAttribute = TextItemOtherAttribute()
        self.zPosition = textItemMO.zPosition!.integerValue
        
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

    
    func getTextColour() -> UIColor {
        return self.otherAttribute.colour
    }
    
    func getTextFont() -> UIFont {
        return self.otherAttribute.font
    }
    
    func getTextAlignment() -> NSTextAlignment {
        return self.otherAttribute.alignment
    }
    
}
