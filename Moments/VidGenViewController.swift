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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.modalPresentationStyle = UIModalPresentationStyle.Popover
        self.preferredContentSize = CGSizeMake(100,100)
        
        let progressHUD = JGProgressHUD(style: .Light)
        progressHUD.textLabel.text = "Creating video..."
        progressHUD.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        progressHUD.showInView(self.view)
        progressHUD.dismissAfterDelay(5)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
