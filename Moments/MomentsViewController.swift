//
//  MomentsViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {

    var fav = false;
    var start = NSDate().dateByAddingTimeInterval(-60*60*24*60);
    var end = NSDate();
    
    
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!

    @IBAction func startDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.setValue(sender.textColor, forKeyPath: "textColor")
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleStartDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    @IBAction func endDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.setValue(sender.textColor, forKeyPath: "textColor")
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleEndDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func playMoments(sender: AnyObject) {
        let vc = VidGenViewController()
        presentViewController(vc, animated: true, completion: nil)
        performSegueWithIdentifier("playVideo", sender: self)
        
        
    }
    
    
    @IBAction func favorite(sender: UIButton) {
        fav = !fav
        if fav {
            let image = UIImage(named: "favourite_unselected_icon")
            sender.setImage(image, forState: UIControlState.Normal)
        }
        else {
            let image = UIImage(named: "favourite_selected_icon")
            sender.setImage(image, forState: UIControlState.Normal)
        }
    }


    func handleStartDatePicker(sender: UIDatePicker){
        if (sender.date.earlierDate(end) == sender.date) {
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateStyle = .MediumStyle
            timeFormatter.timeStyle = .NoStyle
            startDate.text = "Start Date: " + timeFormatter.stringFromDate(sender.date)
            start = sender.date
        }
        else {
            let alert = UIAlertController(title: "Impossible start date!",
                                          message: "The start date you choose must be earlier than the end date. Setting start date to default(2 months ago)",
                                          preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            startDate.text = "Start Date: Default"
            start = NSDate().dateByAddingTimeInterval(-60*60*24*60);
        }
    }
    
    func handleEndDatePicker(sender: UIDatePicker){
        if (sender.date.earlierDate(start) == start) {
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateStyle = .MediumStyle
            timeFormatter.timeStyle = .NoStyle
            endDate.text = "End Date: " + timeFormatter.stringFromDate(sender.date)
            end = sender.date
        }
        else {
            let alert = UIAlertController(title: "Impossible end date!",
                message: "The end date you choose must be later than the start date. Setting end date to default(today)",
                preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            endDate.text = "End Date: Default"
            end = NSDate()
        }

    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.startDate.delegate = self
        self.endDate.delegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let momentsPlayerVC = segue.destinationViewController as! MomentsPlayerViewController
        momentsPlayerVC.fav = fav
        momentsPlayerVC.start = start
        momentsPlayerVC.end = end
    }
}