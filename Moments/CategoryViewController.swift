//
//  CategoryViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-04.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

/*

struct sticker {
    var image : UIImage
    var name : String

}


class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var CategoryCollection: UICollectionView!
    
    private let reuseIdentifier = "CategoryViewCell"
   
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    //--------------------all necessary variables for data model ------------------
    //private var searches = [CategoryEntry]() //current container, this will be changed when user search new category
      private var searches = [sticker]()
    
    
    var home = [Category]()  //read from core data
    var mainpage = [CategoryEntry]() // store all categories into mainpage,
    var categorybook = [ String : [MomentEntry]]() //a dictionary [category.name, [Moments]]
    
  //==============================================================================
    
    //----------------all testing purposes variables-----------------
   // var cell1 = CategoryEntry(colour: UIColor.redColor(),name: "flower")
   // var cell2 = CategoryEntry(colour: UIColor.blueColor(), name: "asdf")
   // var cell3 = CategoryEntry(colour: UIColor.yellowColor(),name: "favourite")
    
    var cell1  = sticker(image : UIImage(named: "sticker-1.png")! , name: "stick1")
   var cell2  = sticker(image : UIImage(named: "sticker-2.png")! , name: "stick1")
    var cell3  = sticker(image : UIImage(named: "sticker-3.png")! , name: "stick1")
    
    
    //private var cells = [CategoryEntry]()
    private var cells = [sticker]()
    
   // func addCells(cell: CategoryEntry ){
    func addCells(cell: sticker ){
        print("adding new cell")
        cells.append(cell)
        
    }
    
    
    
    //===============================================
    
   
    
    
    
    
    //---------------------This function can be put into other places----------------
    
    //this will be later put in CoreDataFetchHelper
   /* func fetchCategoriesFromCoreData() -> [Category] {
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
            if (results.count > 0) {
                for result in results {
                    print(result.name)
                }
            } else {
                print("No Cagetories")
            }
           
            
            return results
        } catch let error as NSError {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }*/

    //==============================================================================
    
    
    
    
    
    //-----------------read data and store-----------------------------------------
   /* func getCategoriesFromCoreData(){
        home = fetchCategoriesFromCoreData()
        print("printing home")
        print(home)
        //mainpage = CoreDataFetchHelper.fetchCategorysFromCoreData()
        
        
    }*/
    /*
    
    func addCategoryFromCoreData(cat : Category){
        
        
        let name =  cat.name!
        let colour  = cat.colour!
        let newcat = CategoryEntry()
        newcat.setName(name)
        newcat.setColour(colour as! UIColor)
        mainpage.append(newcat) // category list on homepage, has color and name
        
        var singleCategory = [MomentEntry]()
        
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
        print("Printing singlecategory")
        print(singleCategory)
        
        
        
    }*/
    
    

    //==============================================================================
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //-------Will be delete-----------
        addCells(cell1)
        addCells(cell2)
        addCells(cell3)
        //================================
        
        
      
        
        
        
        let cellCollNib = UINib (nibName: "CategoryViewCell", bundle: NSBundle.mainBundle())
        CategoryCollection.registerNib(cellCollNib, forCellWithReuseIdentifier: reuseIdentifier)
        
        //getCategoriesFromCoreData()
        
       /* for var i = 0 ; i < home.count; ++i {
            addCategoryFromCoreData(home[i])
           
        }*/
        
        
       // searches = mainpage   // so for searches hould contain all categories, but not moments
       
        //TODO: FIX THE BUG, LABEL CANNOT SHOW UP
        //--------This is for testing purpose---------
        searches = cells
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //should return # of categories
        
        
        return  self.searches.count// for now
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = CategoryCollection.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CategoryViewCell
        
        //print("cell's lable is " + cell.name.text!)
       
        //cell.setCellName(searches[indexPath.row].name)
        
        //cell.name.backgroundColor = UIColor.whiteColor()
        //cell.name.textColor = UIColor.blackColor()
        //cell.name.font = UIFont (name: "HelveticaNeue-UltraLight", size: 350)
        //cell.frame.size.width = self.TestCollection.frame.width/3
        //cell.backgroundColor = UIColor.yellowColor()
        // cell.imageItem.setimage()
        //searches or cells
        //cell class unfinished
        //here i should change lable to categories's name
        //cell = searches[indexPath.row]
        
       /* if let theLabel = cell.viewWithTag(100) as? UILabel {
            theLabel.text = searches[indexPath.row].name
        }*/
        
        
        //cell.setCellName( searches[indexPath.row].name)
        cell.imageItem.image = searches[indexPath.row].image
       // cell.backgroundColor = searches[indexPath.row].colour
        
        return cell
        
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 4.0
        return CGSizeMake(picDimension, picDimension)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// Search Function
/*
extension CategoryViewController : UITextFieldDelegate {
    
    func searchCategory(searchTerm: String) -> Void{
        //var item = categorEntry()
        
        //First need to clear all searches[categoryEntity]
      /*  for item in mainpage {
            if item.name == searchTerm {
                searches.append(item)
            }
        }
     */
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        //todo: Search Class and a function
        /*flickr.searchFlickrForTerm(textField.text) {
        results, error in
        
        //2
        activityIndicator.removeFromSuperview()
        if error != nil {
        println("Error searching : \(error)")
        }
        
        if results != nil {
        //3
        println("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
        self.searches.insert(results!, atIndex: 0)
        
        //4
        self.collectionView?.reloadData()
        }
        }*/
        
        searchCategory(textField.text!)
        // self.view.collectionView?.reloadData()
        //TODO: update collectionview
        //and clear search result
        self.CategoryCollection.reloadData()
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }

    
    
    
    
    
    
}*/




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

*/











