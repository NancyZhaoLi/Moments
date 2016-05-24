//
//  CategoriesViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-05.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class CategoriesViewController: UICollectionViewController, NewCategoryViewControllerDelegate, NewMomentViewControllerDelegate {
    
    @IBOutlet var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var addCategoryButton: UIBarButtonItem!
    
    // snapshot of category cell when moving it
    private var categorySnapshot: UIView?
    // the indexPath of the category cell currently moving
    private var beganIndexPath: NSIndexPath?
    let searchController = UISearchController(searchResultsController: nil)
   
    var categories = [Category]()
    var filteredCategories = [Category]()
    var categoryIdIndex: CategoryIdIndexEntry?
    
    var width: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by category's title"
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        
        //self.searchController.searchBar.delegate = self
        
        
        getCategoriesFromCoreData()
        getCategoryMapsFromCoreData()
        sortCategories()
        
        let cellNib = UINib(nibName: "CategoryViewCell", bundle: NSBundle.mainBundle())
        categoriesCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "CategoryViewCell")
        
        // category page background UI
        self.categoriesCollectionView.showsVerticalScrollIndicator = false
        self.categoriesCollectionView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(246/255.0), alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.customGreenColor()
        
        
        // collection view UI
        navigationController!.toolbarHidden = true
        navigationItem.leftBarButtonItem = editButtonItem()
        
        width = CGRectGetWidth(collectionView!.frame) / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width!, height: width!)
        
        // gesture recognizer
        let longPressGR = UILongPressGestureRecognizer(target: self, action: "longPress:")
        self.categoriesCollectionView.addGestureRecognizer(longPressGR)
        
        global.setCategoriesViewController(self)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "categoryMoments" {
            let categoryMomentsVC = segue.destinationViewController as! CategoryMomentsViewController
            categoryMomentsVC.category = sender as? Category
        } else if segue.identifier == "newCategory" {
            let newCategoryVC = segue.destinationViewController as! NewCategoryViewController
            newCategoryVC.newCategoryDelegate = self
        } else if segue.identifier == "CategoryToNewMoment" {
            let newMomentNavigationVC = segue.destinationViewController as! NewMomentNavigationController
            newMomentNavigationVC.setDelegate(self)
        }
    }
    
    func newMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("new moment in home view")
        
        if moment.save() {
            print("after saving a new moment")
            
            if let home = global.getHomeViewController() {
                home.newMoment(moment)
            }
        }
        
    }
    //==================Monica add thess filter for categories ================
    func filterCategoryUserId(categoryArray : [Category]) -> [Category] {
        var returnArray = [Category]()
        for index in 0 ... (categoryArray.count-1){
            if categoryArray[index].getCategoryUserId() == ref.authData.uid {
                print("Current category id is " + categoryArray[index].getCategoryUserId())
                print("Current user id is " + ref.authData.uid)
                returnArray.append(categoryArray[index])
            }
        }
        return returnArray
    }
    func filterCategoryUserIdWithConditions(categoryArray : [Category], UnCategorized : Bool, favourite: Bool) -> [Category] {
        var returnArray = [Category]()
        for index in 0 ... (categoryArray.count-1){
            if categoryArray[index].getCategoryUserId() == ref.authData.uid {
                print("Current category id is " + categoryArray[index].getCategoryUserId())
                print("Current user id is " + ref.authData.uid)
                returnArray.append(categoryArray[index])
            }else if UnCategorized {
                if categoryArray[index].getName() == "Uncategorized" {
                    returnArray.append(categoryArray[index])
                }
            }else if favourite {
                if categoryArray[index].getName() == "Favourite" {
                    returnArray.append(categoryArray[index])
                }
            }else { print("Not belong to this UserId")}
        }
        return returnArray
    }
    //=====================end of filter ======================================================
    
    func updateMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("update moment in home view")
        
    }
    
    // get categories from core data
    func getCategoriesFromCoreData(){
        categories = CoreDataFetchHelper.fetchCategoriesMOFromCoreData()
        //self.categories = filterCategoryUserIdWithConditions(self.categories, UnCategorized: true, favourite: true)
    }
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredCategories = categories.filter{category in
        return category.name.lowercaseString.containsString(searchText.lowercaseString)}
        categoriesCollectionView.reloadData()
    
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
    
    
    // delete feature
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        if !editing {
            navigationController!.setToolbarHidden(true, animated: animated)
        }
        
        addCategoryButton.enabled = !editing
        searchController.searchBar.userInteractionEnabled = !editing
        searchController.searchBar.translucent = !editing
        if editing {
        searchController.searchBar.alpha = 0.5
        }
        else{
        searchController.searchBar.alpha = 1
        }
        categoriesCollectionView.allowsMultipleSelection = editing
        
        let indexPaths = categoriesCollectionView.indexPathsForVisibleItems() as [NSIndexPath]
        
        for indexPath in indexPaths {
            
            let index = indexPath.row
            
            var id = categories[index].getId()
            if searchController.active && searchController.searchBar.text != ""{
                id = filteredCategories[index].getId()
            }
            
            if (id != 0 && id != 1) {
                categoriesCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
                
                let cell = categoriesCollectionView.cellForItemAtIndexPath(indexPath) as! CategoryViewCell
                cell.deleting = editing
            }
        }
        
    }
    
    // delete categories
    @IBAction func deleteCategories(sender: UIBarButtonItem) {
        
        var indexPaths = categoriesCollectionView.indexPathsForSelectedItems()! as [NSIndexPath]
        
        // delete categories in core data
        // delete categories in array
        var indexes: [Int] = []
        
        for indexPath in indexPaths {
            let index = indexPath.row
            
            var id = categories[index].getId()
            if (searchController.active && searchController.searchBar.text != ""){
                id = filteredCategories[index].getId()
            }
            if (id != 0 && id != 1) {
                categories[index].delete()
                indexes.append(index)
            } else {
                if let removeIndex = indexPaths.indexOf(indexPath) {
                    indexPaths.removeAtIndex(removeIndex)
                }
            }
            
        }
        
        var newCategories: [Category] = []
        
        for var index = 0; index < categories.count; index++ {
            let category = categories[index]
            
            if !indexes.contains(index) {
                newCategories.append(category)
            }
        }
        
        categories = newCategories
        
        print("done delete categories in core data and array")
        
        // update maps
        categoryIdIndex?.idToIndex.removeAllObjects()
        categoryIdIndex?.indexToId.removeAllObjects()
        
        for var index = 0; index < categories.count; index++ {
            let category = categories[index]
            let id = Int(category.getId())
            
            categoryIdIndex?.idToIndex.setObject(index, forKey: id)
            categoryIdIndex?.indexToId.setObject(id, forKey: index)
            
        }
        CoreDataSetHelper.setCategoryIdIndexInCoreData(categoryIdIndex!)
        
        // delete categories in collection view
        categoriesCollectionView.deleteItemsAtIndexPaths(indexPaths)
        
    }
    
    // draging categories
    func longPress(longPressGR: UILongPressGestureRecognizer) {
        
        if editing {
            return
        }
        
        let longPressLoc = longPressGR.locationInView(self.categoriesCollectionView)
        let curIndexPath = self.categoriesCollectionView.indexPathForItemAtPoint(longPressLoc)
        
        if let c = curIndexPath {
            print("curIndexPath: \(c.row)")
        } else {
            print("curIndexPath is nil")
        }
        

        switch longPressGR.state {
            
        case .Began:
            print("Began")
            if let curIndexPath = curIndexPath {
                
                let categoryCell = self.categoriesCollectionView.cellForItemAtIndexPath(curIndexPath) as! CategoryViewCell
                
                categorySnapshot = categoryCell.categorySnapshot
                setCategorySnapshot(categoryCell.center, alpha: 0.0, transform: CGAffineTransformIdentity)
                self.categoriesCollectionView.addSubview(categorySnapshot!)
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.setCategorySnapshot(categoryCell.center, alpha: 0.9, transform: CGAffineTransformMakeScale(1.1, 1.1))
                    categoryCell.draging = true
                })
                
                beganIndexPath = curIndexPath
                
            }
        case .Changed:
            print("changed")
            
            if let curIndexPath = curIndexPath {
                self.categorySnapshot!.center = longPressLoc
                //From sourceIndexPath to curIndexPath
                switchCategoryPosition(beganIndexPath!, dstIndexPath: curIndexPath)
                
                self.categoriesCollectionView.moveItemAtIndexPath(beganIndexPath!, toIndexPath: curIndexPath)
                
                beganIndexPath = curIndexPath
            }

        default:
            print("default")
            if let indexPath = beganIndexPath {
                let categoryCell = self.categoriesCollectionView.cellForItemAtIndexPath(indexPath) as! CategoryViewCell
                
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    self.setCategorySnapshot(categoryCell.center, alpha: 0.0, transform: CGAffineTransformIdentity)
                    categoryCell.draging = false
                    }, completion: { (finished: Bool) -> Void in
                        self.categorySnapshot!.removeFromSuperview()
                        self.categorySnapshot = nil
                })
                
                beganIndexPath = nil
            }
            
        }
    }
    
    // helper function for setting snapshot view of the moving category cell
    private func setCategorySnapshot(center: CGPoint, alpha: CGFloat, transform: CGAffineTransform) {
        
        if let categorySnapshot = categorySnapshot {
            categorySnapshot.center = center
            categorySnapshot.alpha = alpha
            categorySnapshot.transform = transform
            
        }
    }
    
    private func switchCategoryPosition(srcIndexPath: NSIndexPath, dstIndexPath: NSIndexPath) {
        
        if srcIndexPath == dstIndexPath {
            return
        }
        
        let srcIndex = srcIndexPath.row
        let dstIndex = dstIndexPath.row
        let category = categories[srcIndex]

        categories.removeAtIndex(srcIndex)
        categories.insert(category, atIndex: dstIndex)
        
        // update maps
        categoryIdIndex?.idToIndex.removeAllObjects()
        categoryIdIndex?.indexToId.removeAllObjects()
        
        for var index = 0; index < categories.count; index++ {
            let category = categories[index]
            let id = Int(category.getId())
            
            categoryIdIndex?.idToIndex.setObject(index, forKey: id)
            categoryIdIndex?.indexToId.setObject(id, forKey: index)
            
        }
        CoreDataSetHelper.setCategoryIdIndexInCoreData(categoryIdIndex!)
    }

    
    //collection view
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredCategories.count
        }
        return categories.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = categoriesCollectionView.dequeueReusableCellWithReuseIdentifier("CategoryViewCell", forIndexPath: indexPath) as! CategoryViewCell
        let category: Category
        if searchController.active && searchController.searchBar.text != "" {
            category = filteredCategories[indexPath.row]
        }else
        {
            category = categories[indexPath.row]
        }
        cell.deleting = editing
        cell.frame.size.width = width!
        cell.category = category
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var pickedCategory : Category
        if !editing {
            if searchController.active && searchController.searchBar.text != "" {
                pickedCategory = filteredCategories[indexPath.row]
            }
            else{
                pickedCategory = categories[indexPath.row]
            }
            performSegueWithIdentifier("categoryMoments", sender: pickedCategory)
            print("In collection view did select item, Picked category is " + pickedCategory.getName())
            print(pickedCategory.getId())
        } else {
            navigationController!.setToolbarHidden(false, animated: true)
        }
        
        
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if editing {
            if categoriesCollectionView.indexPathsForSelectedItems()!.count == 0 {
                navigationController!.setToolbarHidden(true, animated: true)
            }
            
        }
    }

    
    
    
    // NewCategoryViewController Delegate
    //TODO: go back from create new category in new moment page
    func newCategory(controller: NewCategoryViewController, category: Category) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        print("category id: \(category.id)")
        category.save()
        
        addNewCategory(category)
    
    }
    
    func addNewCategory(newCategory: Category) {
        
        categories.append(newCategory)
        
        let count = categories.count
        let index = count > 0 ? count - 1 : 0
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        let id = Int(newCategory.getId())
        
        // add id and index pair to maps
        categoryIdIndex?.idToIndex.setObject(index, forKey: id)
        print("add to map id: \(id)")
        categoryIdIndex?.indexToId.setObject(id, forKey: index)
        print("updated Keys: \(categoryIdIndex?.idToIndex.keyEnumerator().allObjects)")
        CoreDataSetHelper.setCategoryIdIndexInCoreData(categoryIdIndex!)
        
        /*UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
        self.categoriesCollectionView.insertItemsAtIndexPaths([indexPath])
        }, completion: nil)*/
        
        self.categoriesCollectionView.insertItemsAtIndexPaths([indexPath])
        self.categoriesCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
        
    }

    
    @IBAction func newCategory(sender: AnyObject) {
        let newCategoryVC = NewCategoryViewController(delegate: self)
        presentViewController(newCategoryVC, animated: true, completion: nil)
    }
    
    
}

extension CategoriesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        navigationItem.leftBarButtonItem?.enabled = false
       
        if !searchController.active {
        navigationItem.leftBarButtonItem?.enabled = true
       
        }
    }
   // func searchBarCancelButtonClicked
}

