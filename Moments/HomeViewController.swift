//
//  HomeViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-18.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate {
    
    
    @IBOutlet var homeView: UIView!
    @IBOutlet weak var momentTableView: UITableView!
    
    var moments = [Moment]()
    var filterMoments = [Moment]()
    var indexOfCellClicked: Int?
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Moments by Title..."
        momentTableView.tableHeaderView = searchController.searchBar
        //self.automaticallyAdjustsScrollViewInsets = false
        
        checkDefaultCategories()
        getMomentsFromCoreData()
        
        let cellNib = UINib(nibName: "MomentTableCell", bundle: NSBundle.mainBundle())
        momentTableView.registerNib(cellNib, forCellReuseIdentifier: "MomentTableCell")
        
        self.momentTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.momentTableView.showsVerticalScrollIndicator = false
        self.momentTableView.backgroundColor = UIColor.clearColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        if let NewMomentSavePageVC = segue.sourceViewController as? NewMomentSavePageViewController {
            if NewMomentSavePageVC.isNewMoment() {
                if let moment: Moment = NewMomentSavePageVC.getMomentEntry() {
                    if moment.save() {
                        print("after saving a new moment")
                        moments.insert(moment, atIndex: 0)

                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        self.momentTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        self.momentTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
                    }
                }
            } else {
                if let index = self.indexOfCellClicked {
                    if let moment: Moment = NewMomentSavePageVC.getMomentEntry() {
                        if moment.save() {
                            print("after saving a previously added moment")
                            self.moments[index] = moment
                            momentTableView.reloadData()
                        }
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
    func filterContentForSearchText (searchText: String, scope: String = "ALL")
    {
        
        filterMoments = moments.filter{moment in
            return moment.title.lowercaseString.containsString(searchText.lowercaseString)}
        momentTableView.reloadData()
    
    }
    func checkDefaultCategories(){
        
        let categories = CoreDataFetchHelper.fetchCategoriesMOFromCoreData()
        
        // If no category exists, create 2 default categories
        if categories.count == 0 {
            if let uncategorizedCategory = Category(id: 0, colour: UIColor.customGreenColor(), name: "Uncategorized"){
                uncategorizedCategory.save()
            }
            if let favouriteCategory = Category(id: 1, colour: UIColor.customRedColor(), name: "Favourite") {
                favouriteCategory.save()
            }
            
            var idToIndex = NSMapTable()
            var indexToId = NSMapTable()
            idToIndex.setObject(0, forKey: 0)
            idToIndex.setObject(1, forKey: 1)
            indexToId.setObject(0, forKey: 0)
            indexToId.setObject(1, forKey: 1)
            
            let categoryIdIndex = CategoryIdIndexEntry(idToIndex: idToIndex, indexToId: indexToId)
            CoreDataSaveHelper.saveCategoryIdIndexToCoreData(categoryIdIndex)
            
        }
    }
    
    func getMomentsFromCoreData(){
        moments = CoreDataFetchHelper.fetchMomentsMOFromCoreData()
    }
    
    // moments table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filterMoments.count
        }
        return moments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = momentTableView.dequeueReusableCellWithIdentifier("MomentTableCell", forIndexPath: indexPath) as! MomentTableCell
        let moment: Moment
        if searchController.active && searchController.searchBar.text != ""{
            moment = filterMoments[indexPath.row]
        } else {
            moment = moments[indexPath.row]
        }
        cell.frame.size.width = self.momentTableView.frame.width
        //cell.moment = moments[indexPath.row]
        cell.moment = moment
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
        
        let cell = self.momentTableView.cellForRowAtIndexPath(indexPath) as! MomentTableCell
        print("cell at \(indexPath.row) is clicked")
        self.indexOfCellClicked = indexPath.row
        
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
extension HomeViewController : UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
