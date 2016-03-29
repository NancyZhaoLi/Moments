//
//  HomeViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-18.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, NewMomentViewControllerDelegate {
    
    
    @IBOutlet var homeView: UIView!
    @IBOutlet weak var momentTableView: UITableView!
    
    var moments = [Moment]()
    var filterMoments = [Moment]()
    var localNewMoments = [Moment]()
    var localEditMoments = [Moment]()
    
    var indexOfCellClicked: Int?
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("global new moment count: \(global.getNewMoments().count)")
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search moments by title..."
        momentTableView.tableHeaderView = searchController.searchBar
        //self.automaticallyAdjustsScrollViewInsets = false
        
        checkDefaultCategories()
        getMomentsFromCoreData()
        
        let cellNib = UINib(nibName: "MomentTableCell", bundle: NSBundle.mainBundle())
        momentTableView.registerNib(cellNib, forCellReuseIdentifier: "MomentTableCell")
        
        self.momentTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.momentTableView.showsVerticalScrollIndicator = false
        self.momentTableView.backgroundColor = UIColor.clearColor()
        
        global.setHomeViewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        /*
        print("first moment title: " + moments[0].getTitle())
        
        let newMoments = global.getNewMoments()
        let editMoments = global.getEditMoments()
        
        for newMoment in newMoments {
            if !localNewMoments.contains(newMoment) {
                print("Home not contain new moment")
                
                moments.insert(newMoment, atIndex: 0)
                localNewMoments.append(newMoment)
                
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.momentTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.momentTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
            }
        }
        
        for editMoment in editMoments {
            if !localEditMoments.contains(editMoment) {
                print("Home not update edited moment")
                
                localEditMoments.append(editMoment)
                
                print("first moment title: " + moments[0].getTitle())
                
                for var i = 0; i < moments.count; i++ {
                    print("moment title: \(moments[i].getId())")
                    print("edit moment title \(editMoment.getId())")
                    if moments[i].getId() == editMoment.getId() {
                        print("id match")

                        self.moments[i] = editMoment
                        let indexPath = NSIndexPath(forRow: i, inSection: 0)
                        momentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                    }
                }
                
            }
        }*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        if let NewMomentSavePageVC = segue.sourceViewController as? NewMomentSavePageViewController {
            /*if NewMomentSavePageVC.isNewMoment() {
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
                            let indexPath = NSIndexPath(forRow: index, inSection: 0)
                            momentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                        }
                    }
                }
            }*/
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSavedMoment" {
            let newMomentNavigationVC = segue.destinationViewController as! NewMomentNavigationController
            let cell = sender as! MomentTableCell
            newMomentNavigationVC.setDelegate(self)
            newMomentNavigationVC.loadMoment(cell.moment!)
        } else if segue.identifier == "HomeToNewMoment" {
            let newMomentNavigationVC = segue.destinationViewController as! NewMomentNavigationController
            newMomentNavigationVC.setDelegate(self)
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
    
    func getMomentsFromCoreData() {
        moments = CoreDataFetchHelper.fetchMomentsMOFromCoreData()
    }
    
    func getMoreMomentsFromCoreData(beforeDate: NSDate) {
        
        let moreMoments = CoreDataFetchHelper.fetchMomentsBeforeDateFromCoreData(beforeDate)
        
        for moment in moreMoments {
            moments.append(moment)
        }
        
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
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let preIndex = moments.count - 1
        
        if (indexPath.row == preIndex) {
            //print("reach end of row")
            
            //getMoreMomentsFromCoreData((moments[preIndex].getDate()))
            //print("moments count: \(moments.count)")
            
            /*
            var moreIndexPaths = [NSIndexPath]()

            for var i = preIndex; i < moments.count; i++ {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                moreIndexPaths.append(indexPath)
            }
            */
            
            //momentTableView.reloadData()
            //momentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            
        }
        
    }
    
    func newMoment(newMoment: Moment) {
        moments.insert(newMoment, atIndex: 0)
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        momentTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        momentTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
    }
    
    func updateMoment(updatedMoment: Moment) {
        for moment in moments {
            if moment.getId() == updatedMoment.getId() {
                if let index = moments.indexOf(moment) {
                    moments[index] = updatedMoment
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    momentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                }
            }
        }
    }
    
    func newMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("new moment in home view")
        
        if moment.save() {
            print("after saving a new moment")
            moments.insert(moment, atIndex: 0)
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.momentTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.momentTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)

        }

    }
    
    func updateMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("update moment in home view")
        
        if let index = self.indexOfCellClicked {
            print("index in home view: \(index)")
            if moment.save() {
                print("after saving a previously added moment")
                self.moments[index] = moment
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                momentTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
        }
        
    }


}
extension HomeViewController : UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
