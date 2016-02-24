//
//  MomentsPlayerViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class MomentsPlayerViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.webView.delegate = self
        
        let fileURL = NSURL(fileURLWithPath: "/Users/nancyli/Programming/Moments/Moments/moments.mp4")

        webView.loadHTMLString("<iframe width = \" \(self.webView.frame.width*3) \" height = \" \(self.webView.frame.height*3)\" src = \"\(fileURL)\" </iframe>", baseURL: nil)
        print(self.webView.frame.width)
        print(self.webView.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}