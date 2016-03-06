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
        
        testing()
        
        //getCategoriesFromCoreData()
        
        let cellNib = UINib(nibName: "CategoryViewCell", bundle: NSBundle.mainBundle())
        categoriesCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: "CategoryViewCell")
        
        self.categoriesCollectionView.showsVerticalScrollIndicator = false
        self.categoriesCollectionView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(246/255.0), alpha: 1.0)
        
        width = CGRectGetWidth(collectionView!.frame) / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width!, height: width!)
    }
    
    func testing() {
        let cell1 = CategoryEntry(colour: UIColor.redColor(),name: "flower")
        let cell2 = CategoryEntry(colour: UIColor.blueColor(), name: "animal")
        let cell3 = CategoryEntry(colour: UIColor.yellowColor(),name: "favourite")
        let cell4 = CategoryEntry(colour: UIColor.redColor(),name: "work")
        let cell5 = CategoryEntry(colour: UIColor.blueColor(), name: "study")
        let cell6 = CategoryEntry(colour: UIColor.yellowColor(),name: "play")
        
        categories.append(cell1)
        categories.append(cell2)
        categories.append(cell3)
        categories.append(cell4)
        categories.append(cell5)
        categories.append(cell6)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            addCategoryFromCoreData(categoriesMO[i])
        }
        
    }
    
    func getCategoriesMOFromCoreData(){
        categoriesMO = CoreDataFetchHelper.fetchCategoriesMOFromCoreData()
    }
    
    func addCategoryFromCoreData(categoryMO: Category) {
        let colour =  categoryMO.colour as! UIColor
        let name = categoryMO.name
        var category = CategoryEntry(colour: colour, name: name!)
        
        for momentMO in categoryMO.containedMoment! {
            let moment = MomentEntry(momentMO: momentMO as! Moment)
            category.addMoment(moment)
            
        }
        
        categories.append(category)

    }
    
    
    //collection view
    
    
    @IBAction func addNewCategory(sender: AnyObject) {
        
        let newCategory = CategoryEntry(colour: UIColor.blueColor(),name: "test")
        categories.append(newCategory)
        
        let count = categories.count
        let index = count > 0 ? count - 1 : 0
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.categoriesCollectionView.insertItemsAtIndexPaths([indexPath])
            }, completion: nil)

        self.categoriesCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
    }
    
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

