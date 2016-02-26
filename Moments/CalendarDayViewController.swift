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
    
    var momentsMO = [Moment]()
    var moments = [MomentEntry]()
    
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
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundImage")!)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM dd, YYYY"
        let dateString = formatter.stringFromDate(date!)
        dateLabel.text = dateString
    }
    
    func getMomentsFromCoreData(){
        
        getDayMomentsMOFromCoreData()
        
        for var i = 0; i < momentsMO.count; ++i {
            addMomentFromCoreData(momentsMO[i])
        }
        
    }
    
    func getDayMomentsMOFromCoreData(){
        momentsMO = CoreDataFetchHelper.fetchDayMomentsMOFromCoreData(date!)
    }
    
    func addMomentFromCoreData(momentMO: Moment) {
        let id =  momentMO.id?.longLongValue
        let date = momentMO.date
        let title = momentMO.title
        var moment = MomentEntry(id: id!, date: date!, title: title!)
        
        for textItemMO in momentMO.containedTextItem! {
            let textItem = TextItemEntry(textItemMO: textItemMO as! TextItem)
            moment.addTextItemEntry(textItem)
        }
        
        for imageItemMO in momentMO.containedImageItem! {
            let imageItem = ImageItemEntry(imageItemMO: imageItemMO as! ImageItem)
            moment.addImageItemEntry(imageItem)
        }
        
        moments.append(moment)

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
        if (moments[indexPath.row].imageItemEntries.count > 0) {
            return 185
        }
        return 120
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.dayMomentTableView.cellForRowAtIndexPath(indexPath) as! MomentTableCell
        print("cell at \(indexPath.row) is clicked")
        //self.indexOfCellClicked = indexPath.row
        //performSegueWithIdentifier("editSavedMoment", sender: cell)
    }

    
}