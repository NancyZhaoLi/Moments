//
//  MomentsViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class MomentsViewController: UIViewController, UITextFieldDelegate {

    var fav = false;
    
    @IBOutlet weak var startDate: UITextField!

    
    @IBOutlet weak var endDate: UITextField!

    @IBAction func startDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleStartDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    @IBAction func endDate(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleEndDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func playMoments(sender: AnyObject) {
        print("generating video")
    }
    
    
    @IBAction func favorite(sender: UIButton) {
        fav = !fav
        if fav {
            let image = UIImage(named: "FavouriteSelected")
            sender.setImage(image, forState: UIControlState.Normal)        }
        else {
            let image = UIImage(named: "Favourite")
            sender.setImage(image, forState: UIControlState.Normal)        }
    }


    func handleStartDatePicker(sender: UIDatePicker){
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .MediumStyle
        timeFormatter.timeStyle = .NoStyle
        startDate.text = "Start Date: " + timeFormatter.stringFromDate(sender.date)
    }
    
    func handleEndDatePicker(sender: UIDatePicker){
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .MediumStyle
        timeFormatter.timeStyle = .NoStyle
        endDate.text = "End Date: " + timeFormatter.stringFromDate(sender.date)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.startDate.delegate = self
        self.endDate.delegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundImage3")!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}