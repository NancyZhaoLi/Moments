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
    var indexOfCellClicked: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMomentsFromCoreData()
        
        let cellNib = UINib(nibName: "MomentTableCell", bundle: NSBundle.mainBundle())
        momentTableView.registerNib(cellNib, forCellReuseIdentifier: "MomentTableCell")
        
        self.momentTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.momentTableView.showsVerticalScrollIndicator = false
        self.momentTableView.backgroundColor = UIColor.clearColor()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundImage")!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        if let NewMomentSavePageVC = segue.sourceViewController as? NewMomentSavePageViewController {
            if NewMomentSavePageVC.isNewMoment() {
                if let moment: MomentEntry = NewMomentSavePageVC.getMomentEntry() {
                    CoreDataSaveHelper.saveNewMomentToCoreData(moment)
                    moments.insert(moment, atIndex: 0)
                    //getMomentsMOFromCoreData()
                    let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                    self.momentTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    self.momentTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
                }
            } else {
                if let index = self.indexOfCellClicked {
                    if let moment: MomentEntry = NewMomentSavePageVC.getMomentEntry() {
                        CoreDataSaveHelper.saveNewMomentToCoreData(moment)
                        self.moments[index] = moment
                        momentTableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSavedMoment" {
            let newMomentNavigationVC = segue.destinationViewController as! NewMomentNavigationController
            let cell = sender as! MomentTableCell
            let vc = newMomentNavigationVC.topViewController as! NewMomentCanvasViewController
            vc.loadedMoment = cell.moment
         }
    }
    
    func getMomentsFromCoreData(){
        getMomentsMOFromCoreData()
        for momentMO in momentsMO {
            moments.append(MomentEntry(momentMO: momentMO))
        }
    }
    
    func getMomentsMOFromCoreData(){
        momentsMO = CoreDataFetchHelper.fetchMomentsMOFromCoreData()
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
        if (moments[indexPath.row].imageItemEntries.count > 0) {
            return 185
        }
        return 120
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.momentTableView.cellForRowAtIndexPath(indexPath) as! MomentTableCell
        print("cell at \(indexPath.row) is clicked")
        self.indexOfCellClicked = indexPath.row
        performSegueWithIdentifier("editSavedMoment", sender: cell)
    }


}
