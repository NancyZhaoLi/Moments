//
//  NewViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-19.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {
    
    @IBAction func addItem(sender: AnyObject) {
        if sender.title == "Text" {
            var myTextView: UITextView = UITextView(frame: CGRect(x: 100, y: 100, width: 100.00, height: 60.00));
            myTextView.text = "..."
            myTextView.editable = true
            myTextView.layer.borderWidth = 2
            myTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.view.addSubview(myTextView)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("New moment loaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}