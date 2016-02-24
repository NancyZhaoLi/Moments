//
//  CalendarDayViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarDayViewController: UIViewController {
    var date:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("Calendar day loaded")
        print("Day: \(date!)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}