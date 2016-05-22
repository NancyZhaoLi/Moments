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
    let searchController = UISearchController(searchResultsController: nil)
    var moments = [Moment]()
    var filterMoments = [Moment]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search moments by title ..."
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.view.backgroundColor =  UIColor.customBackgroundColor()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let cellNib = UINib (nibName:"MomentTableCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "MomentTableCell")
        self.tableView.separatorStyle=UITableViewCellSeparatorStyle.None
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = UIColor.clearColor()
        
        //moments = CoreDataFetchHelper.fetchMomentsMOFromCoreData()
        moments = CoreDataFetchHelper.fetchTrashedMomentsFromCoreData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.moments = CoreDataFetchHelper.fetchTrashedMomentsFromCoreData()
        self.tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func filterContentForSearchText(searchText:String, scope: String = "ALL"){
        filterMoments = moments.filter{moment in
        return moment.title.lowercaseString.containsString(searchText.lowercaseString)}
        self.tableView.reloadData()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        if searchController.active && searchController.searchBar.text != ""{
            return filterMoments.count
        }
        return self.moments.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        //cell.textLabel!.text = self.dawgs[indexPath.row]
        let cell=tableView.dequeueReusableCellWithIdentifier("MomentTableCell", forIndexPath: indexPath) as! MomentTableCell
        let moment: Moment
        if searchController.active && searchController.searchBar.text != "" {
            moment = filterMoments[indexPath.row]
        }else{
            moment = moments[indexPath.row]
        }
        cell.frame.size.width = self.tableView.frame.width
        //cell.frame.size.height = 100
        cell.moment = moment
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
   
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (moments[indexPath.row].numOfImage() > 0) {
            return 185
        }
        return 120
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var recoverAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default,title: "Recover", handler: {
            (
                action:UITableViewRowAction!, indexPath:NSIndexPath!
            ) -> Void in
            if self.searchController.active && self.searchController.searchBar.text != "" {
                self.filterMoments[indexPath.row].setMomentUnTrashed()
                self.filterMoments.removeAtIndex(indexPath.row)
            }else{
            self.moments[indexPath.row].setMomentUnTrashed()
            self.moments.removeAtIndex(indexPath.row)
            
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default,title: "Delete", handler: {
            (
            action:UITableViewRowAction!, indexPath:NSIndexPath!
            ) -> Void in
            if self.searchController.active && self.searchController.searchBar.text != ""{
            self.filterMoments[indexPath.row].delete()
            self.filterMoments.removeAtIndex(indexPath.row)
            }else{
            self.moments[indexPath.row].delete()
                self.moments.removeAtIndex(indexPath.row)}
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
        })
        recoverAction.backgroundColor = UIColor(red: 0.349, green: 0.8392, blue: 0, alpha: 1.0)
        return[deleteAction,recoverAction]
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
extension TrashViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
