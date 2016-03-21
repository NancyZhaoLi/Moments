//
//  DragToTrash.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-20.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

protocol DragToTrashDelegate{
    func trashItem(view:UIView)
}

class DragToTrash {
    
    var delegate: DragToTrashDelegate
    var trashView: UIView
    var radius: CGFloat
    var alertTitle: String?
    var alertMessage: String?
    var itemToTrash: UIView?
    
    
    init(delegate: DragToTrashDelegate, trashView: UIView, alertTitle: String?, alertMessage: String?, radius: CGFloat) {
        self.delegate = delegate
        self.trashView = trashView
        self.radius = radius
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
    }
    
    convenience init(delegate: DragToTrashDelegate, trashView: UIView, alertTitle: String?, alertMessage: String?) {
        self.init(delegate: delegate, trashView: trashView, alertTitle: alertTitle, alertMessage: alertMessage, radius: 0.0)
    }
    
    func draggedView(senderView: UIView) {
        itemToTrash = senderView
        if closeToTrash() == true {
            self.itemToTrash = senderView
            delete()
        }
    }
    
    private func closeToTrash() -> Bool {
        if let item = itemToTrash?.frame {
            let trash = trashView.frame
            
            if (item.minX > trash.maxX || item.maxX < trash.minX || item.minY > trash.maxY || item.maxY < trash.minY) == false {
                print("item minX: \(item.minX)")
                print("item maxX: \(item.maxX)")
                print("trash minX: \(trash.minX)")
                print("trash maxX: \(trash.maxX)")
                print("item minY: \(item.minY)")
                print("item maxY: \(item.maxY)")
                print("trash minY: \(trash.minY)")
                print("trash maxY: \(trash.maxY)")
                return true
            }
            return false
        }
        return false
    }
    
    private func delete() {
        if let title = alertTitle, message = alertMessage {
            let viewController = delegate as! UIViewController
            let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler:
                { (action: UIAlertAction) in
                    self.delegate.trashItem(self.itemToTrash!)
                    viewController.view.userInteractionEnabled = true
            })
            let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: {
                (action: UIAlertAction) in
                viewController.view.userInteractionEnabled = true
            })
            alert.addAction(yes)
            alert.addAction(no)
            viewController.view.userInteractionEnabled = false
            viewController.presentViewController(alert, animated: true, completion: nil)
        } else {
            delegate.trashItem(self.itemToTrash!)
        }
    }
}
