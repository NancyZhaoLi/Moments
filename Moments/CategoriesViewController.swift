//
//  File.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-05.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class CategoriesViewController: UICollectionViewController, NewCategoryViewControllerDelegate {
    
    @IBOutlet var categoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var addCategoryButton: UIBarButtonItem!
   
    var categoriesMO = [Category]()
    var categories = [CategoryEntry]()
    
    var width: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategoriesFromCoreData()
        
        let cellNib = UINib(nibName: "CategoryViewCell", bundle: NSBundle.mainBundle())
        categoriesCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "CategoryViewCell")
        
        // category page background UI
        self.categoriesCollectionView.showsVerticalScrollIndicator = false
        self.categoriesCollectionView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(246/255.0), alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationController?.navigationBar.barTintColor = UIColor.customGreenColor()
        
        
        // collection view UI
        navigationController!.toolbarHidden = true
        navigationItem.leftBarButtonItem = editButtonItem()
        
        width = CGRectGetWidth(collectionView!.frame) / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width!, height: width!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "categoryMoments" {
            let categoryMomentsVC = segue.destinationViewController as! CategoryMomentsViewController
            categoryMomentsVC.category = sender as? CategoryEntry
        } else if segue.identifier == "newCategory" {
            let newCategoryVC = segue.destinationViewController as! NewCategoryViewController
            newCategoryVC.delegate = self
        }
    }
    
    // get categories from core data
    func getCategoriesFromCoreData(){
        getCategoriesMOFromCoreData()
        for var i = 0; i < categoriesMO.count; ++i {
            categories.append(CategoryEntry(categoryMO: categoriesMO[i]))
        }
    }
    
    func getCategoriesMOFromCoreData(){
        categoriesMO = CoreDataFetchHelper.fetchCategoriesMOFromCoreData()
    }
    
    
    // delete feature
    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        if !editing {
            navigationController!.setToolbarHidden(true, animated: animated)
        }
        
        addCategoryButton.enabled = !editing
        
        //TODO: allow multiple selection
        //categoriesCollectionView.allowsMultipleSelection = editing
        categoriesCollectionView.allowsMultipleSelection = false
        
        let indexPaths = categoriesCollectionView.indexPathsForVisibleItems() as [NSIndexPath]
        
        for indexPath in indexPaths {
            //categoriesCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
            
            let cell = categoriesCollectionView.cellForItemAtIndexPath(indexPath) as! CategoryViewCell
            cell.deleting = editing
        }
        
    }
    
    
    @IBAction func deleteCategories(sender: UIBarButtonItem) {
        
        let indexPaths = categoriesCollectionView.indexPathsForSelectedItems()! as [NSIndexPath]
        
        // delete categories in core data
        for indexPath in indexPaths {
            CoreDataDeleteHelper.deleteCategoriesMOFromCoreData(categoriesMO[indexPath.row])
            categoriesMO.removeAtIndex(indexPath.row)
            categories.removeAtIndex(indexPath.row)
            
        }
        
        // delete categories in collection view
        categoriesCollectionView.deleteItemsAtIndexPaths(indexPaths)
        
    }
    
    
    //collection view
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = categoriesCollectionView.dequeueReusableCellWithReuseIdentifier("CategoryViewCell", forIndexPath: indexPath) as! CategoryViewCell
        
        cell.deleting = editing
        cell.frame.size.width = width!
        cell.category = categories[indexPath.row]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !editing {
            let pickedCategory = categories[indexPath.row]
            performSegueWithIdentifier("categoryMoments", sender: pickedCategory)
            
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
    func newCategory(controller: NewCategoryViewController, category: CategoryEntry) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        let categoryMO = CoreDataSaveHelper.saveCategoryToCoreData(category)
        categories.append(category)
        categoriesMO.append(categoryMO)
        
        let count = categories.count
        let index = count > 0 ? count - 1 : 0
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        
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

