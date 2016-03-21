//
//  NewMomentSavePageViewController.swift
//  
//
//  Created by Xin Lin on 2016-02-23.
//
//

import UIKit

class NewMomentSavePageViewController: UIViewController,
    UITableViewDelegate,
    UIViewControllerTransitioningDelegate,
    NewCategoryViewControllerDelegate,
    UITextFieldDelegate {
    
    var canvas : NewMomentCanvasViewController?
    var manager : NewMomentManager?
    var categories : [CategoryEntry] = [CategoryEntry]()
    var selectedCell: UITableViewCell?

    @IBOutlet weak var momentTitleDisplay: UITextField!
    @IBOutlet weak var categoryList: UITableView!
    
    @IBAction func newCategory(sender: AnyObject) {
        let newCategoryVC = NewCategoryViewController(delegate: self)
        presentViewController(newCategoryVC, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager!.setSavePage(self)
        self.momentTitleDisplay.delegate = self
        
        displayCategories()
        
        self.categoryList.separatorStyle = UITableViewCellSeparatorStyle.None
        self.categoryList.showsVerticalScrollIndicator = false
        self.categoryList.backgroundColor = UIColor.clearColor()
    }
    
    func displayCategories() {
        let categoriesMO = CoreDataFetchHelper.fetchCategoriesMOFromCoreData()
    
        for categoryMO in categoriesMO {
            let category = CategoryEntry(categoryMO: categoryMO)
            categories.append(category)
            //print("category name: " + category.name)
        }
        
        //print("number of categories: " + String(categories.count))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveNewMoment"{
            self.manager!.saveMomentEntry()
        } else if segue.identifier == "newCategory" {
            let newCategoryVC = segue.destinationViewController as! NewCategoryViewController
            newCategoryVC.delegate = self
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setDefaultMomentTitle(title: String) {
        momentTitleDisplay.placeholder = title
    }
    
    func setDefaultMomentCategory(category: String) {
        //momentCategoryDisplay.placeholder = category
    }
    
    func setMomentTitle(title: String) {
        momentTitleDisplay.text = title
    }
    
    func setMomentCategory(category: String) {
        //momentCategoryDisplay.text = category
    }
    
    func getMomentEntry() -> MomentEntry {
        return self.manager!.moment!
    }
    
    func getTitle() -> String {
        if let title = self.momentTitleDisplay.text {
            if title.isEmpty {
                return self.momentTitleDisplay.placeholder!
            }
            return title
        } else {
            print("no title text")
            return self.momentTitleDisplay.placeholder!
        }
    }
    
    func isNewMoment() -> Bool {
        return manager!.isNewMoment
    }
    
    // NewCategoryViewController Delegate
    func newCategory(controller: NewCategoryViewController, category: CategoryEntry) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        CoreDataSaveHelper.saveCategoryToCoreData(category)
        categories.append(category)
        
        let count = categories.count
        let index = count > 0 ? count - 1 : 0
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        self.categoryList.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }

    
    // Category List - UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("category count: " + String(categories.count))
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CategoryCell")
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let previousCell = self.selectedCell {
            previousCell.backgroundColor = UIColor.whiteColor()
            previousCell.textLabel?.textColor = UIColor.blackColor()
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.backgroundColor = UIColor.blueColor()
            cell.textLabel?.textColor = UIColor.whiteColor()
            self.selectedCell = cell
            self.manager!.momentCategory = cell.textLabel!.text!
        }
    }
    
    // UITextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
