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
    
    @IBAction func setCanvasBackground(sender: AnyObject) {
        self.delegate!.setCanvasBackground(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
