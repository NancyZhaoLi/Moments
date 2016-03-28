//
//  NewMomentNavigationController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-17.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class NewMomentNavigationController: UINavigationController {
    
    var newMomentDelegate: NewMomentViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDelegate(delegate: NewMomentViewControllerDelegate) {
        self.newMomentDelegate = delegate
    }

}
