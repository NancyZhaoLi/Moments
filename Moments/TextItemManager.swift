//
//  TextItemManager.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-09.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class TextItemManager : ItemManager {
    
    var textItems : [TextItemViewController] = [TextItemViewController]()
    
    override init() {
        super.init()
        super.type = ItemType.Text
        super.debugPrefix = "[TextItemManager] - "
    }
    
    func addText(text: String, location: CGPoint, textAttribute: TextItemOtherAttribute) -> TextItemViewController {
        debugBegin("addText")
        
        let newTextVC = TextItemViewController(manager: self)
        newTextVC.addText(text, location: location, textAttribute: textAttribute)
        self.textItems.append(newTextVC)
        
        debugEnd("[addText]")
        return newTextVC
        
    }
    
    func loadText(textItem: TextItemEntry) -> TextItemViewController {
        let newTextVC = TextItemViewController(manager: self)
        newTextVC.addText(textItem)
        self.textItems.append(newTextVC)
        
        return newTextVC
    }
    
    override func saveAllItemEntry() {
        var id = getId()
        
        for textItem in textItems {
            let view = textItem.view as! UITextView
            var textItemEntry = TextItemEntry(id: id, frame: view.frame)
            textItemEntry.setContent(view.text)
            textItemEntry.setOtherAttribute(view.textColor!, font: view.font!, alignment: view.textAlignment)
            
            super.superManager!.addTextItemEntry(textItemEntry)
            id += 1
        }
    }
}
