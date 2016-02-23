//
//  MomentsViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController {

    
    @IBAction func setStartDate(sender: UIButton) {
        //Create the view
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        
        
        var datePickerView  : UIDatePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePickerView.datePickerMode = UIDatePickerMode.Date
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRectMake((self.view.frame.size.width/2) - (100/2), 0, 100, 50))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: "doneButton:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        
        self.view.addSubview(inputView)
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        
        handleDatePicker(datePickerView) // Set the date on start.
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //datePicker.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneButton(sender:UIButton)
    {
        //datePicker.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    
    @IBAction func setEndDate(sender: AnyObject) {
        
    }
    
    
}
