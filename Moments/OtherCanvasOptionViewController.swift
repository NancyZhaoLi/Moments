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
                popover.sourceRect = CGRectMake(sourceView.frame.width/2.0,0,0,0)
            }
            self.preferredContentSize = self.view.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func initUI() {
        self.view = UIView(frame: CGRectMake(0,0,120,30))
        self.view.bounds = self.view.frame
        self.view.backgroundColor = UIColor.whiteColor()
        
        let background = ButtonHelper.textButton("Background", frame: self.view.frame, target: self, action: "setCanvasBackground")
        background.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        self.view.addSubview(background)
    }
    
    func setCanvasBackground() {
        self.dismissViewControllerAnimated(false, completion: nil)
        self.removeFromParentViewController()
        if let delegate = self.delegate {
            delegate.setCanvasBackground(self)
        }
    }
}
