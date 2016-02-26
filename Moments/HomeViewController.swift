//
//  HomeViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-02-18.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet var homeView: UIView!
    @IBOutlet weak var momentTableView: UITableView!
    
    var momentsMO = [Moment]()
    var moments = [MomentEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMomentsFromCoreData()
        
        let cellNib = UINib(nibName: "MomentTableCell", bundle: NSBundle.mainBundle())
        momentTableView.registerNib(cellNib, forCellReuseIdentifier: "MomentTableCell")
        
        self.momentTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.momentTableView.showsVerticalScrollIndicator = false
        self.momentTableView.backgroundColor = UIColor.clearColor()
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundImage")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        if let NewMomentSavePageVC = segue.sourceViewController as? NewMomentSavePageViewController {
            
            if let moment: MomentEntry = NewMomentSavePageVC.getMomentEntry() {
                CoreDataSaveHelper.saveNewMomentToCoreData(moment)
                moments.append(moment)
                getMomentsMOFromCoreData()
                let indexPath = NSIndexPath(forRow: moments.count - 1, inSection: 0)
                self.momentTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.momentTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSavedMoment" {
            let newMomentCanvasVC = segue.destinationViewController as!NewMomentCanvasViewController
            let cell = sender as! MomentTableCell
            newMomentCanvasVC.loadedMoment = cell.moment
        }
    }
    
    func getMomentsFromCoreData(){
        
        getMomentsMOFromCoreData()
            
        for var i = 0; i < momentsMO.count; ++i {
            addMomentFromCoreData(momentsMO[i])
        }
        
    }
    
    func getMomentsMOFromCoreData(){
        momentsMO = CoreDataFetchHelper.fetchMomentsMOFromCoreData()
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
        print("id: \(id!), date: \(date!), title: \(title!)")
    }
    
    // moments table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = momentTableView.dequeueReusableCellWithIdentifier("MomentTableCell", forIndexPath: indexPath) as! MomentTableCell
        
        cell.frame.size.width = self.momentTableView.frame.width
        cell.moment = moments[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.momentTableView.cellForRowAtIndexPath(indexPath) as! MomentTableCell
        print("cell at \(indexPath.row) is clicked")
        performSegueWithIdentifier("editSavedMoment", sender: cell)
    }


}
