//
//  CategoryMomentsViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-05.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit


class CategoryMomentsViewController: UIViewController, UITableViewDelegate, NewMomentViewControllerDelegate, EditCategoryViewControllerDelegate {
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var momentsTableView: UITableView!

    var category: Category?
    var moments = [Moment]()
    var indexOfCellClicked: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCategoryNameLabel()
        getMomentsInCategory()
        print(moments.count)
        
        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: "MomentTableCell", bundle: NSBundle.mainBundle())
        momentsTableView.registerNib(cellNib, forCellReuseIdentifier: "MomentTableCell")
        
        self.momentsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.momentsTableView.showsVerticalScrollIndicator = false
        self.momentsTableView.backgroundColor = UIColor.clearColor()
        
        self.view.backgroundColor = UIColor.customGreenColor()
        
        initUI()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue")
        if segue.identifier == "editSavedMoment" {
            let newMomentNavigationVC = segue.destinationViewController as! NewMomentNavigationController
            newMomentNavigationVC.setDelegate(self)
            
            let cell = sender as! MomentTableCell
            newMomentNavigationVC.loadMoment(cell.moment)
        }
    }
    
    private func initUI() {
        let backButton = NavigationHelper.leftNavButton("Back", target: self, action: "backToCategory")
        let settingButton = NavigationHelper.rightNavButtonWithImage("setting_icon.png", target: self, action: "categorySetting")
        let navBar = NavigationHelper.barWithItem(backButton, centerItem: nil, rightItem: settingButton)
        self.view.addSubview(navBar)
    }
    
    func newMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("new moment in home view")
        
    }
    
    func updateMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("update moment in home view")
        
        if let index = self.indexOfCellClicked {
            if moment.save() {
                print("after saving a previously added moment")
                
                if moment.getCategory() == category {
                    self.moments[index] = moment
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    momentsTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                } else {
                    self.moments.removeAtIndex(index)
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    momentsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
                if let home = global.getHomeViewController() {
                    home.updateMoment(moment)
                }
                
            }
        }
    }

    
    func backToCategory() {
        self.dismiss(true)
    }
    
    func categorySetting() {
        if let category = self.category {
            let editCategory = NewCategoryViewController(delegate: self, categoryName: category.getName(), categoryColour: category.getColour())
            presentViewController(editCategory, animated: true, completion: nil)
        }
    }
    
    func updateCategoryNameLabel() {
        categoryName.text = category?.name
    }

    func getMomentsInCategory() {
        
        if category!.id != 1 {
            
            let name = category?.getName()
            let updatedCategory = CoreDataFetchHelper.fetchCategoryGivenName(name!)
            
            for moment in (updatedCategory.getSortedSavedMoments()) {
                print("moment in category")
                moments.append(moment)
            }
        } else {
            moments = CoreDataFetchHelper.fetchFavouriteMomentsFromCoreData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = momentsTableView.dequeueReusableCellWithIdentifier("MomentTableCell", forIndexPath: indexPath) as! MomentTableCell
        
        cell.frame.size.width = self.momentsTableView.frame.width
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
        let cell = self.momentsTableView.cellForRowAtIndexPath(indexPath) as! MomentTableCell
        print("cell at \(indexPath.row) is clicked")
        self.indexOfCellClicked = indexPath.row
        
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("editSavedMoment", sender: cell)
        })
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            if let home = global.getHomeViewController() {
                home.deleteMoment(moments[indexPath.row])
            }
            
            // delete moment in core data
            moments[indexPath.row].delete()
            
            // delete categories in array
            moments.removeAtIndex(indexPath.row)
            
            // delete cell in table
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func editCategory(controller: NewCategoryViewController, categoryName: String, categoryColour: UIColor) {
        if let category = self.category {
            category.setCategoryName(categoryName)
            category.setCategoryColour(categoryColour)
            category.save()
            updateCategoryNameLabel()
        }
    }
}