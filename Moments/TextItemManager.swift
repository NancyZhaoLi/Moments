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
    
    func addText(textView: UITextView, location: CGPoint) -> TextItemViewController {
        return addText(textView.text, textColour: textView.textColor!, textFont: textView.font!, textAlignment: textView.textAlignment, location: location)
    }
    
    func addText(text: String, textColour: UIColor, textFont: UIFont, textAlignment: NSTextAlignment, location: CGPoint) -> TextItemViewController {
        debugBegin("addText")
        
        let width : CGFloat = UIScreen.mainScreen().bounds.size.width - 20 - location.x
        var height : CGFloat = ((CGFloat(text.length) / width) + 5) * 20
        let textItemView = UITextView(frame: CGRectMake(location.x, location.y, width, height))
        let textItemVC = TextItemViewController()
        
        textItemView.text = text
        textItemView.textColor = textColour
        textItemView.font = textFont
        textItemView.textAlignment = textAlignment
        textItemView.backgroundColor = UIColor.clearColor()
        
        textItemVC.view = textItemView
        self.textItems.append(textItemVC)
        
        debugEnd("[addText]")
        return textItemVC
        
    }
    
    func loadText(textItem: TextItemEntry) -> TextItemViewController {
        let textItemView = UITextView(frame: textItem.getFrame())
        let textItemVC = TextItemViewController()
        textItemView.text = textItem.getContent()
        textItemView.textColor = textItem.getTextColour()
        textItemView.font = textItem.getTextFont()
        textItemView.textAlignment = textItem.getTextAlignment()
        textItemView.backgroundColor = UIColor.clearColor()
        
        textItemVC.view = textItemView
        self.textItems.append(textItemVC)
        return textItemVC
    }
    
    
    override func saveAllItemEntry() {
        var id = getId()
        
        for textItem in textItems {
            let view = textItem.view as! UITextView
            var textItemEntry = TextItemEntry(id: id, frame: view.frame)
            textItemEntry.setContent(view.text)
            textItemEntry.setOtherAttribute(view.textColor!, font: view.font!, alignment: view.textAlignment)
            super.superManager?.addTextItemEntry(textItemEntry)
            
            id += 1
        }
    }
}
