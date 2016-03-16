//
//  OtherOptionViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class OtherCanvasOptionViewController: UIViewController {

    var delegate: NewMomentCanvasViewController?
    
    convenience init() {
        self.init(sourceView: nil, delegate: nil)
    }
    
    init(sourceView: UIView?, delegate: NewMomentCanvasViewController?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        initUI()
        
        self.modalPresentationStyle = .Popover
        if let popover = self.popoverPresentationController {
            popover.delegate = self.delegate as? UIPopoverPresentationControllerDelegate
            popover.permittedArrowDirections = .Any
            if let sourceView = sourceView {
                popover.sourceView = sourceView
                popover.sourceRect = CGRectMake(sourceView.frame.width/2.0,25,0,0)
            }
            self.preferredContentSize = self.view.frame.size
        }
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func initUI() {
        self.view = UIView(frame: CGRectMake(0,0,120,30))
        self.view.bounds = self.view.frame
        self.view.backgroundColor = UIColor.whiteColor()
        
        let background = UIButton(frame: CGRectMake(0,0,120,30))
        background.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        background.setTitle("Backgound", forState: .Normal)
        background.addTarget(self, action: "setCanvasBackground", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(background)
    }
    
    func setCanvasBackground() {
        if let delegate = self.delegate {
            self.dismissViewControllerAnimated(false, completion: nil)
            delegate.setCanvasBackground(self)
        } else {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
