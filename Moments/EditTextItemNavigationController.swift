//
//  EditTextItemNavigationController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-26.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class EditTextItemNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootVC = super.topViewController as! EditTextItemViewController
        rootVC.delegate = self.delegate as! EditTextItemViewControllerDelegate
        let settingVC = super.viewControllers[1] as! EditTextItemSettingViewController
        settingVC.parentVC = rootVC
    }
    
}