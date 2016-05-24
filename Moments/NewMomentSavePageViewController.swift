//
//  NewMomentSavePageViewController.swift
//  
//
//  Created by Xin Lin on 2016-02-23.
//
//

//**************************Important*****************************************
//The category bug is that when a new moment is saved in a (new) category before all category saved/sorted or initilized instead, it will save nil to index for a new born category
//So here, we should do sth looks exactly the same with CategoriesViewController.swift
//If you have another solution, please add it.
//****************************************************************************


import UIKit

protocol NewMomentViewControllerDelegate {
    func newMoment(controller: NewMomentSavePageViewController, moment: Moment)
    func updateMoment(controller: NewMomentSavePageViewController, moment: Moment)
}

class NewMomentSavePageViewController: UIViewController,
    UITableViewDelegate,
    UIViewControllerTransitioningDelegate,
    NewCategoryViewControllerDelegate,
    UITextFieldDelegate {
    
    var canvas : NewMomentCanvasViewController?
    var manager : NewMomentManager?
    var delegate : NewMomentViewControllerDelegate?
    private var categories : [Category] = [Category]()
    private var selectedCell: UITableViewCell?
    private var selectedCategory: Category?
    
    //====================Monica add this (for fixing category bug)===========
    private var categoryIdIndex: CategoryIdIndexEntry?
    //========================================================================
    
    @IBOutlet weak private var momentTitle: UITextField!
    @IBOutlet weak private var categoryList: UITableView!
    @IBOutlet weak private var favourite: UIButton!
    
    @IBAction func saveMoment(sender: AnyObject) {
        print("save button pressed")
        let animation = true
        if let navigationController = self.navigationController  {
            self.dismissViewControllerAnimated(true, completion: nil)
            navigationController.removeFromParentViewController()
        } else {
            self.dismissViewControllerAnimated(animation, completion: nil)
        }
        self.removeFromParentViewController()
        
        self.manager!.saveMomentEntry()
        if let delegate = self.delegate {
            if self.isNewMoment() {
                delegate.newMoment(self, moment: self.getMomentEntry())
            } else {
                delegate.updateMoment(self, moment: self.getMomentEntry())
            }
        } else {
            print("no delegate for save page")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if self.manager != nil {
            self.manager!.setSavePage(self)
            self.momentTitle.delegate = self
            //----------------Monica: We also setup for category index --------------------
            getCategoriesFromCoreData()
            getCategoryMapsFromCoreData()
            sortCategories()
            //---------------------------------------------------------------------
            initCategoryListUI()
            displayCategories()
            
        } else {
            print("Manager not set for savePage")
        }
    }
    
    private func initCategoryListUI() {
        self.categoryList.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        self.categoryList.showsVerticalScrollIndicator = false
        self.categoryList.backgroundColor = UIColor.clearColor()
    }
    
    private func displayCategories() {
        categories = Category.fetchOtherCategories()
        let uncategorized = Category.fetchUncategorized()
        categories.insert(uncategorized, atIndex: 0)
        for var i = 0; i < categories.count; i++ {
            let category = categories[i]
            if category.getName() == selectedCategory!.getName() {
                let index = NSIndexPath(forRow: i, inSection: 0)
                categoryList.selectRowAtIndexPath(index, animated: false, scrollPosition: .Middle)
                break
            }
        }
        
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newCategory" {
            let newCategoryVC = segue.destinationViewController as! NewCategoryViewController
           // newCategoryVC.delegate = self
            newCategoryVC.newCategoryDelegate = self
            print("i'm here in newCategoryVC")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    /******************************************************************************
    Monica: Functions should be able to solve the category bug
    ******************************************************************************/
    func getCategoriesFromCoreData(){
        categories = CoreDataFetchHelper.fetchCategoriesMOFromCoreData()
        //self.categories = filterCategoryUserIdWithConditions(self.categories, UnCategorized: true, favourite: true)
    }

    func getCategoryMapsFromCoreData() {
        
        let fetchResult = CoreDataFetchHelper.fetchCategoryIdIndexFromCoreData()
        
        if fetchResult.count > 0 {
            categoryIdIndex = CategoryIdIndexEntry(categoryIdIndexMO: fetchResult[0])
            
            //Testing:===========================
            
            let idToIndex = categoryIdIndex?.idToIndex
            let indexToId = categoryIdIndex?.indexToId
            
            print("maps count: \(idToIndex?.count)")
            print("Keys: \(idToIndex!.keyEnumerator().allObjects)")
            print("Add another one: \(indexToId?.count)")
            //print(categoryIdIndex.userID)
            //=================Testing======================
        } else {
            print("2 default categories id and index not saved into maps")
        }
        
    }
    
    func sortCategories() {
        
        var tempCategories = [Category]()
        print ("the total cateogories is " + String(categories.count))
        for var i = 0; i < categories.count; i++ {
            tempCategories.append(Category())
        }
        
        for category in categories {
            
            print("sort- category id: \(category.getId())")
            
            let id = Int(category.getId())
            let index = categoryIdIndex?.idToIndex.objectForKey(id) as! Int
            //Monica recommend this: comment out the index and use id instead
            // Bug is that the new category didn't get the new index
            //print(index)
            tempCategories[index] = category
            
        }
        
        categories = tempCategories
        
        for category in categories {
            print("sorted category id: \(category.getId())")
        }
    }
    /*********************************************************************************

     FUNCTIONS CALLED BY MANAGER
     *********************************************************************************/
    func setInitialMomentTitle(title: String) {
        momentTitle.placeholder = title
    }

    func setInitialMomentCategory(category: Category?) {
        if let category = category {
            self.selectedCategory = category
        }
    }
    
    func setInitialMomentFavourite(favourite: Bool) {
        if favourite {
            selectFavourite()
        } else {
            cancelFavourite()
        }
    }
    
    func getTitle() -> String {
        if let title = self.momentTitle.text {
            if title.isEmpty {
                return self.momentTitle.placeholder!
            }
            return title
        } else {
            print("no title text")
            return self.momentTitle.placeholder!
        }
    }
    
    /*********************************************************************************
     
     FAVOURITE
     *********************************************************************************/

    func selectFavourite() {
        print("select favourite")
        favourite.setImage(UIImage(named: "favourite_selected_icon.png")!, forState: .Normal)
        favourite.removeTarget(self, action: "selectFavourite")
        favourite.addTarget(self, action: "cancelFavourite")
        manager!.selectFavourite()
    }
    
    func cancelFavourite() {
        print("unselect favourite")
        favourite.setImage(UIImage(named: "favourite_unselected_icon.png")!, forState: .Normal)
        favourite.removeTarget(self, action: "cancelFavourite")
        favourite.addTarget(self, action: "selectFavourite")
        manager!.cancelFavourite()
    }

    /*********************************************************************************
     
     NEW CATEGORY
     *********************************************************************************/
    
    @IBAction func newCategory(sender: AnyObject) {
        let newCategoryVC = NewCategoryViewController(delegate: self)
        presentViewController(newCategoryVC, animated: true, completion: nil)
    }
    
    /*********************************************************************************
     
     FUNCTION CALLED AFTER SAVE BUTTON IS CLICKED
     *********************************************************************************/
    private func isNewMoment() -> Bool {
        return manager!.isNewMoment
    }
    
    private func getMomentEntry() -> Moment {
        return self.manager!.moment!
    }
    
    
    /*********************************************************************************
     
     DELEGATE FUNCTIONS
     *********************************************************************************/
    // NewCategoryViewController Delegate
    func newCategory(controller: NewCategoryViewController, category: Category) {
        controller.dismissViewControllerAnimated(true, completion: nil)
     /*
     //====================Monica add these trying to fix the bug========================
       var idToIndex = NSMapTable()
       var indexToId = NSMapTable()
       idToIndex.setObject(category.id, forKey: category.id)
       indexToId.setObject(category.id, forKey: category.id)
      // print(index)
        
        var categoryIdIndex = CategoryIdIndexEntry(idToIndex: idToIndex, indexToId: indexToId)
        //categoryIdIndex.userID = ref.authData.uid
        //CoreDataSaveHelper.saveCategoryIdIndexToCoreData(categoryIdIndex, userId: ref.authData.uid)
        print("updated Keys: \(categoryIdIndex.idToIndex.keyEnumerator().allObjects)")
        CoreDataSetHelper.setCategoryIdIndexInCoreData(categoryIdIndex)
    //=====================End of this section========Bug was not fixed=========Have to load category page first, then bug is gone=============================
*/
        //Continue on fixing the bug
        
        
        print("category id: \(category.id)")
        //print("Category index:" \(category.i)
        category.save()
        categories.append(category)
        
        let count = categories.count
        let index = count > 0 ? count-1  : 0
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        self.categoryList.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        categoryIdIndex?.idToIndex.setObject(index,forKey: category.id)
        categoryIdIndex?.indexToId.setObject(category.id, forKey: index)
        CoreDataSetHelper.setCategoryIdIndexInCoreData(categoryIdIndex!)
        
        
        
        if let categoriesVC = global.getCategoriesViewController() {
            categoriesVC.addNewCategory(category)
        }

        
        
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
        if let previousCell = selectedCell {
            previousCell.backgroundColor = UIColor.whiteColor()
            previousCell.textLabel?.textColor = UIColor.blackColor()
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.backgroundColor = UIColor.blueColor()
            cell.textLabel?.textColor = UIColor.whiteColor()
            selectedCell = cell
            manager!.momentCategory = categories[indexPath.row]
        }
    }
    
    // UITextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
