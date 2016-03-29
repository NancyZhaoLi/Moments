//
//  CalendarDayViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

class CalendarDayViewController: UIViewController, UITableViewDelegate, NewMomentViewControllerDelegate {
    
    var date:NSDate?
    var indexOfCellClicked: Int?
    
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
        
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSavedMoment" {
            let newMomentNavigationVC = segue.destinationViewController as! NewMomentNavigationController
            let cell = sender as! MomentTableCell
            newMomentNavigationVC.setDelegate(self)
            newMomentNavigationVC.loadMoment(cell.moment!)
        }
    }
    
    private func initUI() {
        let backButton = NavigationHelper.leftNavButton("Back", target: self, action: "backToCalendar")
        let navBar = NavigationHelper.barWithItem(backButton, centerItem: nil, rightItem: nil)
        self.view.addSubview(navBar)
    }
    
    func newMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("new moment in calendar view")
        
    }
    
    func updateMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("update moment in calendar view")
        
        if let index = self.indexOfCellClicked {
            print("index: \(index)")
            if moment.save() {
                print("after saving a previously added moment")
                self.moments[index] = moment
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                dayMomentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                
                //global.addEditMoment(moment)
                if let home = global.getHomeViewController() {
                    home.updateMoment(moment)
                }
            }
            
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
    
    func backToCalendar() {
        self.dismiss(true)
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
        self.indexOfCellClicked = indexPath.row
        print("cell at \(indexPath.row) is clicked")
        
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("editSavedMoment", sender: cell)
        })
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // delete moment in core data
            moments[indexPath.row].delete()
            
            // delete categories in array
            moments.removeAtIndex(indexPath.row)
            
            // delete cell in table
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

    
}