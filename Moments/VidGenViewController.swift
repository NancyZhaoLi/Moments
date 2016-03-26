//
//  VidGenViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-03-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import JGProgressHUD

class VidGenViewController: UIViewController {
    
    var fav : Bool!
    var start :  NSDate!
    var end : NSDate!
    var path:String!
    
    let progressHUD = JGProgressHUD(style: .Light)
    let t = true
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.modalPresentationStyle = UIModalPresentationStyle.Popover

        VideoGeneration.videoGeneration(fav, start: start, end: end, path: path)
        
        progressHUD.textLabel.text = "Creating video..."
        progressHUD.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        progressHUD.showInView(self.view)
        progressHUD.dismissAfterDelay(5)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.dismissViewControllerAnimated(false, completion: {})
    }
}
