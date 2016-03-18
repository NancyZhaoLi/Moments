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


class StickerViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    private let reuseIdentifier = "StickerViewCell"
    
    @IBOutlet weak var stickerCollection: UICollectionView!
    
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout ()
    let cellSpacing : CGFloat = 3
    let cellsPerRow : CGFloat = 3
  
   private var cells = [sticker]()

    private var searches = [sticker]()
    func addCells(cell: sticker ){
        print("adding new cell")
        cells.append(cell)
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.stickerCollection.delegate = self
       // self.stickerCollection.dataSource = self
        
        for i  in 1 ... 16 {
            
            let name : String = "sticker-" + String(i) + ".png"
            let pic = sticker(image: UIImage(named: name)!, name: "sticker")
            addCells(pic)
            
        
        }
        
        
        let cellCollNib = UINib (nibName: "StickerViewCell", bundle: NSBundle.mainBundle())
        stickerCollection.registerNib(cellCollNib, forCellWithReuseIdentifier: reuseIdentifier)
        
        


          searches = cells
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        let cellSize = (stickerCollection.collectionViewLayout.collectionViewContentSize().width / cellsPerRow ) - (cellSpacing)
        //layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        stickerCollection.collectionViewLayout = layout
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
         var imageView : UIImageView
        //???????????????
        imageView = UIImageView (frame: CGRectMake(5,5, (stickerCollection.collectionViewLayout.collectionViewContentSize().width / cellsPerRow) - (cellSpacing ), (stickerCollection.collectionViewLayout.collectionViewContentSize().width / cellsPerRow) - (cellSpacing)))
       //???????????????
     
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = searches[indexPath.row].image
        cell.addSubview(imageView)
        
      // cell.imageItem.image = searches[indexPath.row].image
        // cell.backgroundColor = searches[indexPath.row].colour
        
        return cell
        
    }
    
    
   /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = self.view.frame.size.width / 4.0
        return CGSizeMake(picDimension, picDimension)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0
        return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
