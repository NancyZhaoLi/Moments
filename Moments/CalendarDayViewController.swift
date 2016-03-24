//
//  CalendarDayViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

class CalendarDayViewController: UIViewController, UITableViewDelegate {
    
    var date:NSDate?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dayMomentTableView: UITableView!
    
    var moments = [Moment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("Calendar day loaded")
        print("Day: \(date!)")
        
        updateDateLabel()
        getMomentsFromCoreData()
        print(moments.count)
    
        let cellNib = UINib(nibName: "MomentTableCell", bundle: NSBundle.mainBundle())
        dayMomentTableView.registerNib(cellNib, forCellReuseIdentifier: "MomentTableCell")
        
        self.dayMomentTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.dayMomentTableView.showsVerticalScrollIndicator = false
        self.dayMomentTableView.backgroundColor = UIColor.clearColor()
        
        self.view.backgroundColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(246/255.0), alpha: 1.0)
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundImage")!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSavedMoment" {
            let newMomentNavigationVC = segue.destinationViewController as! NewMomentNavigationController
            let newMomentCanvasVC = newMomentNavigationVC.topViewController as! NewMomentCanvasViewController
            let cell = sender as! MomentTableCell
            newMomentCanvasVC.loadedMoment = cell.moment
        }
    }
    
    func updateDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        let dateString = formatter.stringFromDate(date!)
        dateLabel.text = dateString
    }
    
    func getMomentsFromCoreData(){
        moments = CoreDataFetchHelper.fetchDayMomentsMOFromCoreData(date!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = dayMomentTableView.dequeueReusableCellWithIdentifier("MomentTableCell", forIndexPath: indexPath) as! MomentTableCell
        
        cell.frame.size.width = self.dayMomentTableView.frame.width
        cell.moment = moments[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (moments[indexPath.row].numOfImage() > 0) {
            return 185
        }
        return 120
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.dayMomentTableView.cellForRowAtIndexPath(indexPath) as! MomentTableCell
        print("cell at \(indexPath.row) is clicked")
        
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("editSavedMoment", sender: cell)
        })
    }

    
}