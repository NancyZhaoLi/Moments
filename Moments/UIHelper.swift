//
//  SegueHelper.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-18.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(center: CGPoint, size: CGSize) {
        self.init(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: size))
        self.center = center
    }
    
    convenience init(center: CGPoint, width: CGFloat) {
        self.init(center: center, size: CGSize(width: width, height: width))
    }
    
    func addTarget(target: AnyObject?, action: Selector?) {
        if let action = action {
            self.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        }
    }
    
    func removeTarget(target: AnyObject?, action: Selector?) {
        if let action = action {
            self.removeTarget(target, action: action, forControlEvents: .TouchUpInside)
        }
    }
}

extension UIViewController {
    func dismiss(animation: Bool) {
        if let navigationController = self.navigationController  {
            if navigationController.viewControllers.first! != self {
                navigationController.popViewControllerAnimated(animation)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
                navigationController.removeFromParentViewController()
            }
        }
        else {
            self.dismissViewControllerAnimated(animation, completion: nil)
        }
        self.removeFromParentViewController()
    }
}

class SegueHelper {
    

}

class LabelHelper: UIHelper {
    

}


class ButtonHelper: UIHelper {
    static func imageButton(imageName: String, frame: CGRect, target: AnyObject?, action: Selector?) -> UIButton {
        let button = UIButton(frame: frame)
        setImageButton(button, imageName: imageName, target: target, action: action)
        return button
    }
    
    static func imageButton(imageName: String, center: CGPoint, imageSize: CGFloat, target: AnyObject?, action: Selector?) -> UIButton {
        let button = UIButton(center: center, width: imageSize)
        setImageButton(button, imageName: imageName, target: target, action: action)
        return button
    }
    
    static private func setImageButton(button: UIButton, imageName: String, target: AnyObject?, action: Selector?) {
        if var image = UIImage(named: imageName) {
            image = resizeImage(image, newWidth: button.frame.size.width)
            button.setImage(image, forState: .Normal)
        } else {
            print("[ERROR: failed to find image with name \(imageName) ]")
        }
        button.addTarget(target, action: action)
    }

    
    static func textButton(text: String, frame: CGRect, target: AnyObject?, action: Selector?) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(text, forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(target, action: action)
        
        return button
    }
    
    static func whiteTextButton(text: String, frame: CGRect, target: AnyObject?, action: Selector?) -> UIButton {
        let button = textButton(text, frame: frame, target: target, action: action)
        button.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
        
        return button
    }
}

class ToolbarHelper: ButtonHelper {
    
    static func getCenter(y: CGFloat, totalItems: Int, inset: CGFloat) -> [CGPoint] {
        var centers = [CGPoint]()
        for var currentItem = 0; currentItem < totalItems; currentItem++ {
            centers.append(getCenter(y, currentItem: currentItem, totalItems: totalItems, inset: inset))
        }
        
        return centers
    }
    
    static private func getCenter(y: CGFloat, currentItem: Int, totalItems: Int, inset: CGFloat) -> CGPoint {
        let barSize = windowWidth - inset * 2
        let curPortion: CGFloat = 1 + 2 * CGFloat(currentItem)
        let totalPortion: CGFloat = 2 * CGFloat(totalItems)
        
        let x = inset + barSize * curPortion / totalPortion
        
        return CGPointMake(x, y)
    }
    
    
}

class NavigationHelper: ButtonHelper {
    static let navBtnX: CGFloat = 20.0
    static let navBtnY: CGFloat = 3.0
    static let navBtnSize: CGFloat = 37.0
    static let navBarHeight: CGFloat = 64.0
    
    static func leftNavButtonWithImage(imageName: String, target: AnyObject?, action: Selector?) -> UIButton {
        let frame = CGRectMake(navBtnX, navBtnY, navBtnSize, navBtnSize)
        let button = imageButton(imageName, frame: frame, target: target, action: action)
        
        return button
    }
    
    static func leftNavButton(title: String, target: AnyObject?, action: Selector?) -> UIButton {
        let frame = CGRectMake(navBtnX, navBtnY, buttonWidth(title), navBtnSize)
        let button = textButton(title, frame: frame, target: target, action: action)
        button.contentHorizontalAlignment = .Left
        
        return button
    }
    
    static func rightNavButtonWithImage(imageName: String, target: AnyObject?, action: Selector?) -> UIButton {
        let frame = CGRectMake(windowWidth - navBtnSize,navBtnY,navBtnSize,navBtnSize)
        let button = imageButton(imageName, frame: frame, target: target, action: action)
        
        return button
    }
    
    static func rightNavButton(title: String, target: AnyObject?, action: Selector?) -> UIButton {
        let width = buttonWidth(title)
        let x = windowWidth - navBtnX - width
        let frame = CGRectMake(x, navBtnY, width, navBtnSize)
        let button = textButton(title, frame: frame, target: target, action: action)
        button.contentHorizontalAlignment = .Right
        
        return button
    }
    
    
    static func centerButton(text: String, target: AnyObject?, action: Selector?) -> UIButton {
        let frame = CGRect(origin: CGPointMake(0,0), size: CGSizeMake(buttonWidth(text), navBtnSize))
        
        return textButton(text, frame: frame, target: target, action: action)
    }
    
    static func emptyBar() -> UINavigationBar {
        return emptyBar(0)
    }
    
    static func emptyBar(inset: CGFloat) -> UINavigationBar {
        var navBar = UINavigationBar()
        navBar = UINavigationBar(frame: CGRectMake(inset,0,windowWidth - inset, navBarHeight))
        navBar.barTintColor = UIColor.customGreenColor()
        
        return navBar
    }
    
    static func barWithItem(leftItem: UIView?, centerItem: UIView?, rightItem: UIView?) -> UINavigationBar {
        return barWithItem(0, leftItem: leftItem, centerItem: centerItem, rightItem: rightItem)
    }
    
    static func barWithItem(inset:CGFloat, leftItem: UIView?, centerItem: UIView?, rightItem: UIView?) -> UINavigationBar {
        let navBar = emptyBar(inset)
        let navItem = UINavigationItem()

        if let leftItem = leftItem {
            navItem.leftBarButtonItem = UIBarButtonItem(customView: leftItem)
        }
        navItem.titleView = centerItem
        if let rightItem = rightItem {
            navItem.rightBarButtonItem = UIBarButtonItem(customView: rightItem)
        }
        navBar.pushNavigationItem(navItem, animated: false)
        
        return navBar
    }
}

class UIHelper {
    static private func buttonWidth(text: String) -> CGFloat {
        return textSize(text, size: 15.0).width + 2 * 5
    }
    
    static func textSize(text: String, size: CGFloat) -> CGSize {
        return textSize(text, font: UIFont.systemFontOfSize(size))
    }
    
    static func textSize(text: String, font: UIFont) -> CGSize {
        let nsString: NSString = text as NSString
        let textSize: CGSize = nsString.sizeWithAttributes([NSFontAttributeName: font])
        return textSize
    }
    
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = image.size.width/newWidth
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0,0,newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    static func groupWithHeader(header: String, headerSize: CGFloat,lineHeight: CGFloat, inset: CGFloat, y: CGFloat, content: UIView) -> UIView {
        let view = UIView(frame: CGRectMake(0, y, windowWidth,0))
        let labelSize = textSize(header, size: headerSize)
        let label = UILabel(frame:CGRectMake(inset, 0, labelSize.width, labelSize.height))
        label.text = header
        label.font = UIFont.systemFontOfSize(headerSize)
        label.backgroundColor = UIColor.clearColor()
        
        view.backgroundColor = UIColor.clearColor()
        view.addSubview(label)

        if lineHeight > 0 {
            let line = blackLine(inset, y: label.frame.maxY + 1, height: lineHeight)
            view.addSubview(line)
            content.frame.origin.y = line.frame.maxY + 5
        } else {
            content.frame.origin.y = label.frame.maxY + 5
        }
        
        view.frame.size.height = content.frame.maxY
        view.addSubview(content)
        return view
    }
    
    
    static func blackLine(inset: CGFloat, y: CGFloat, height: CGFloat) -> UIView {
        return line(inset, height: height, y:y, colour: UIColor.blackColor())
    }
    static func line(inset: CGFloat, height: CGFloat, y: CGFloat, colour: UIColor) -> UIView {
        let view = UIView(frame: CGRectMake(inset, y, windowWidth - inset * 2.0, height))
        view.backgroundColor = colour
        
        return view
    }
}

