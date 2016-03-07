//
//  NewMomentSavePageViewController.swift
//  
//
//  Created by Xin Lin on 2016-02-23.
//
//

import UIKit

class NewMomentSavePageViewController: UIViewController, UITableViewDelegate {
    
    var canvas : NewMomentCanvasViewController?
    var manager : NewMomentManager?
    var categories : [CategoryEntry] = [CategoryEntry]()
    var selectedCell: UITableViewCell?

    @IBOutlet weak var momentTitleDisplay: UITextField!
    @IBOutlet weak var categoryList: UITableView!
    
    @IBAction func newCategory(sender: AnyObject) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager!.setSavePage(self)
        
        categoryList.delegate = self
        displayCategories()
    }
    
    func displayCategories() {
        self.categories = [CategoryEntry]()
        let categoriesMO = CoreDataFetchHelper.fetchCategoriesMOFromCoreData()
    
        for categoryMO in categoriesMO {
            let category = CategoryEntry(categoryMO: categoryMO)
            categories.append(category)
            print("category name: " + category.name)
        }
        
        print("number of categories: " + String(categories.count))
        categoryList.reloadData()
    }
    
    
    func addCategoryToTable(category: CategoryEntry) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveNewMoment"{
            self.manager!.saveMomentEntry()
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.canvas!.backFromSavePage()
    }
    
    func comeFromFirstView() {
        self.canvas!.dismissViewControllerAnimated(true, completion: nil)
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
        return self.manager!.getIsNewMoment()
    }
    
    
    
    // Category List
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        }
    }
}
