//
//  TextItemViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class TextItemViewController: UIViewController {

    var manager: TextItemManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class TextItemManager : ItemManager {
    
    var textItems : [TextItemViewController] = [TextItemViewController]()
    
    override init() {
        super.init()
        super.type = ItemType.Text
        super.debugPrefix = "[TextItemManager] - "
    }
    
    func addText(textView: UITextView, location: CGPoint) {
        let textItemView = UITextView(frame: CGRectMake(location.x, location.y, 120, 120))
        let textItemVC = TextItemViewController()
        
        textItemView.textAlignment = textView.textAlignment
        textItemView.textColor = textView.textColor
        textItemView.backgroundColor = textView.backgroundColor
        textItemView.text = textView.text
        
        textItemVC.view = textItemView
        
        self.textItems.append(textItemVC)
        super.canvas!.view.addSubview(textItemVC.view)
        super.canvas!.addChildViewController(textItemVC)
    }
    
    override func saveAllItemEntry() {
        var id = getId()
        
        debugBegin("saveAllItemEntry")
        for textItem in textItems {
            let view = textItem.view as! UITextView
            var textItemEntry = TextItemEntry(id: id, frame: view.frame)
            textItemEntry.setContent(view.text)
            super.superManager?.addTextItemEntry(textItemEntry)
            
            id += 1
        }
        
        debug("[saveAllItemEntry] - max text id: " + String(id))
        debugEnd("saveAllItemEntry")
    }
}
