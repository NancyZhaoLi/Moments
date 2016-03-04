//
//  CategoryCollectionViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-02-29.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate {
    
    var home = [Category]()
    var mainpage = [CategoryEntry]()
    var singleCategory = [MomentEntry]()
    var categorybook = [ String : [MomentEntry]]()
    
    
    //need an array of array.
    //categoryEntry doesn;t have an array of moments id or momentsEntities
    
    
   
    
     func fetchCategoriesFromCoreData() -> [Category] {
        let defaultFetchSize = 20
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestCategories = NSFetchRequest(entityName: "Category")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        requestCategories.sortDescriptors = [sortDescriptor]
        requestCategories.returnsObjectsAsFaults = false
        
        requestCategories.fetchLimit = defaultFetchSize
        
        do {
            let results = try context.executeFetchRequest(requestCategories) as! [Category]
            
            return results
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    func getCategoriesFromCoreData(){
       home = fetchCategoriesFromCoreData()
        
        //mainpage = CoreDataFetchHelper.fetchCategorysFromCoreData()
        
    
    }


    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategoriesFromCoreData()
        
        for var i = 0 ; i < home.count; ++i {
            addCategoryFromCoreData(home[i])
            //CategoryEntity is missing a container for moments
        }
        
        //TODO: Then layout the category view
        //Quetion: collection view for category? 
        //what about user what to switch to original home?
        //so what is the best view for category.
        
        //--------In home view it's layout by cellNib, so here i should replace this by categorycell
        
        
        //self.view.addSubview(self.collection)
        
        
        
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    
    
    //add moments into one category
    //Then Record those moments into the dictionary categorybook
    func addCategoryFromCoreData(cat : Category){
      
        
        let name =  cat.name!
        let colour  = cat.colour!
        let newcat = CategoryEntry()
        newcat.setName(name)
        newcat.setColour(colour as! UIColor)
        mainpage.append(newcat) // category list on homepage, has color and name
        
        
        //Category has containedMoment in core data
        
        for catMoment in cat.containedMoment! {
            let date  =   (catMoment as! MomentEntry).date
            let title : String? =  (catMoment as! MomentEntry).title
            let id   =   (catMoment as! MomentEntry).id
            
          
            let eachmoment = MomentEntry( id: id, date: date, title: title!)
            singleCategory.append(eachmoment)
             print(" Created moment: detected in a category \(cat.name):  id: \(id), date: \(date), title: \(title!)")
            //why call momemnt function
        }
        categorybook[name] = singleCategory
        
        
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* NOTES-----------SWITCH VIEWS---------------------------
    http://stackoverflow.com/questions/14139371/how-to-switch-uitableview-and-uicollectionview
    - (void)viewDidLoad
    {
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
    }
    
    - (void)buttonTapped:(id)sender
    {
    UIView *fromView, *toView;
    
    if (self.tableView.superview == self.view)
    {
    fromView = self.tableView;
    toView = self.collectionView;
    }
    else
    {
    fromView = self.collectionView;
    toView = self.tableView;
    }
    
    [fromView removeFromSuperview];
    
    toView.frame = self.view.bounds;
    [self.view addSubview:toView];
    }
    -----------
    If you want a fancy animation, you can use +[UIView transitionFromView:toView:duration:options:completion:] instead:
    -----------
    - (void)buttonTapped:(id)sender
    {
    UIView *fromView, *toView;
    
    if (self.tableView.superview == self.view)
    {
    fromView = self.tableView;
    toView = self.collectionView;
    }
    else
    {
    fromView = self.collectionView;
    toView = self.tableView;
    }
    
    toView.frame = self.view.bounds;
    [UIView transitionFromView:fromView
    toView:toView
    duration:0.25
    options:UIViewAnimationTransitionFlipFromRight
    completion:nil];
    }
    
    
    
    ---------------------------------------------------------*/
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    /*
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }
*/
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
