//
//  File.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-05.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class CategoriesViewController: UICollectionViewController {
    
    @IBOutlet var categoriesCollectionView: UICollectionView!
    
    var categoriesMO = [Category]()
    var categories = [CategoryEntry]()
    
    var width: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategoriesFromCoreData()
        
        let cellNib = UINib(nibName: "CategoryViewCell", bundle: NSBundle.mainBundle())
        categoriesCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "CategoryViewCell")
        
        self.categoriesCollectionView.showsVerticalScrollIndicator = false
        self.categoriesCollectionView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(246/255.0), alpha: 1.0)
        
        width = CGRectGetWidth(collectionView!.frame) / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width!, height: width!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToCategoriesView(segue: UIStoryboardSegue) {
        
        if let newCategoryVC = segue.sourceViewController as? NewCategoryViewController {
                if let category: CategoryEntry = newCategoryVC.getCategoryEntry() {
                    CoreDataSaveHelper.saveCategoryToCoreData(category)
                    categories.append(category)
                    
                    let count = categories.count
                    let index = count > 0 ? count - 1 : 0
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    
                    UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                        self.categoriesCollectionView.insertItemsAtIndexPaths([indexPath])
                        }, completion: nil)
                    
                    self.categoriesCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)

                }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "categoryMoments" {
            let categoryMomentsVC = segue.destinationViewController as! CategoryMomentsViewController
            categoryMomentsVC.category = sender as? CategoryEntry

        }
    }
    
    
    func getCategoriesFromCoreData(){
        
        getCategoriesMOFromCoreData()
        
        for var i = 0; i < categoriesMO.count; ++i {
            categories.append(CategoryEntry(categoryMO: categoriesMO[i]))
        }
        
    }
    
    func getCategoriesMOFromCoreData(){
        categoriesMO = CoreDataFetchHelper.fetchCategoriesMOFromCoreData()
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
        
        cell.frame.size.width = width!
        cell.category = categories[indexPath.row]
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let pickedCategory = categories[indexPath.row]
        performSegueWithIdentifier("categoryMoments", sender: pickedCategory)
        
    }
    
}

