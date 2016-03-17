//
//  StickerViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-17.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit


  struct sticker {
        var image : UIImage
        var name : String
        
    }


class StickerViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate  {
    
    private let reuseIdentifier = "StickerViewCell"
    
    @IBOutlet weak var stickerCollection: UICollectionView!
    
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
  

    private var searches = [sticker]()
    
    
    var cell1  = sticker(image : UIImage(named: "sticker-1.png")! , name: "stick1")
    var cell2  = sticker(image : UIImage(named: "sticker-2.png")! , name: "stick1")
    var cell3  = sticker(image : UIImage(named: "sticker-3.png")! , name: "stick1")
    
    private var cells = [sticker]()
    
    func addCells(cell: sticker ){
        print("adding new cell")
        cells.append(cell)
        
    }
    
    

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.stickerCollection.delegate = self
       // self.stickerCollection.dataSource = self
        
        addCells(cell1)
        addCells(cell2)
        addCells(cell3)
        
        
        let cellCollNib = UINib (nibName: "StickerViewCell", bundle: NSBundle.mainBundle())
        stickerCollection.registerNib(cellCollNib, forCellWithReuseIdentifier: reuseIdentifier)


          searches = cells
        // Do any additional setup after loading the view.
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
        
        print(searches.count)
        return  self.searches.count// for now
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = stickerCollection.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! StickerViewCell
      // let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! StickerViewCell
        
       // print("cell's lable is " + cell.name.text!)
        
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
