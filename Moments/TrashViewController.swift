//
//  TrashViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-05-18.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class TrashViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dawgs = ["snoop", "sarah", "Fido", "Mark", "Jill"]
    var moments = [Moment]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor.customBackgroundColor()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let cellNib = UINib (nibName:"MomentTableCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "MomentTableCell")
        self.tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        self.tableView.showsVerticalScrollIndicator=false
        self.tableView.backgroundColor=UIColor.clearColor()
        
        //moments = CoreDataFetchHelper.fetchMomentsMOFromCoreData()
        moments = CoreDataFetchHelper.fetchTrashedMomentsFromCoreData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)->Int{
    
        return self.moments.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        //cell.textLabel!.text = self.dawgs[indexPath.row]
        let cell=tableView.dequeueReusableCellWithIdentifier("MomentTableCell", forIndexPath: indexPath) as! MomentTableCell
        let moment: Moment
        moment = moments[indexPath.row]
        
        cell.frame.size.width = self.tableView.frame.width
        //cell.frame.size.height = 100
        cell.moment = moment
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
          //self.dawgs.removeAtIndex(indexPath.row)
            //self.tableView.reloadData()
            moments[indexPath.row].delete()
            moments.removeAtIndex(indexPath.row)
            //self.tableView.reloadData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (moments[indexPath.row].numOfImage() > 0) {
            return 185
        }
        return 120
        
    }
    func reportFileSizeOfPersistentStores(){
        //let allStores:NSArray = self.persistentStoreCoordinator.persistentStores
        
        
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
