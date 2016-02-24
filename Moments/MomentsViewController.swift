//
//  MomentsViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController {

    @IBOutlet weak var startDate: UITextField!

    
    @IBOutlet weak var endDate: UITextField!

    
    @IBAction func startDate(sender: UITextField) {
        print("clikc")
        var datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func handleDatePicker(sender: UIDatePicker){
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeStyle = .NoStyle
        startDate.text = timeFormatter.stringFromDate(sender.date)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    
    @IBAction func endDate(sender: AnyObject) {
    }
}
