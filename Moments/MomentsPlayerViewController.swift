//
//  MomentsPlayerViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class MomentsPlayerViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = NSURL(fileURLWithPath: "/Users/nancyli/Programming/Moments/Moments/moments.mp4")
        
        webView.loadHTMLString("<iframe width = \" \(self.webView.frame.width) \" height = \" \(self.webView.frame.height)\" src = \"\(fileURL)\" </iframe>", baseURL: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}