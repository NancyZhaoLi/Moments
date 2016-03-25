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

protocol StickerPickerControllerDelegate {
    func didPickSticker(stickerPicker: StickerViewController, stickerName: String)
}

class StickerButton : UIButton {
    
    var name : String = ""
    /*required init(coder aDecoder: NSCoder){
        name = ""
        super.init(coder: aDecoder)
    }*/
    
}





class StickerViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    private let reuseIdentifier = "StickerViewCell"
    var delegate: StickerPickerControllerDelegate?
    
    @IBOutlet weak var stickerCollection: UICollectionView!
    
    @IBAction func goBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func update(sender: AnyObject) {
      //  fetchNewColStickers("sticker")
       // self.stickerCollection.reloadData()
        //TODO: LOAD STICKERS FROM ICLOUD
        
        
    }
    let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout ()
    let cellSpacing : CGFloat = 3
    let cellsPerRow : CGFloat = 3
    let toolBarHeight : CGFloat = 60
    let iconSize : CGFloat = 30
    let buttonSize : CGFloat = 30
  
   private var cells = [sticker]()
   private var booklet = [String :  Int]()
   private var searches = [sticker]()
    
    
    func addCells(cell: sticker ){
        print("adding new cell")
        cells.append(cell)
        
    }
    func addCellsWithName(cell: sticker, inout name : [sticker] ){
        //print("adding new cell to a particular booklet")
        name.append(cell)
    
    }
    func fetchNewColStickers(name : String){
        if name != "" {
        let colnum : Int = booklet[name]!
        var newcell = [sticker]()
       
        
        for i in 1...colnum {
            let name_sticker : String = name + "-" + String(i) + ".png"
            let pic = sticker(image: UIImage(named: name_sticker)!, name: name_sticker)
            addCellsWithName(pic, name: &newcell )
        
        
        searches = newcell
        }
    }
        else{
         print("no sticer's name!")
        
        }
      
    
    }
    
    
    override func viewWillAppear(animated: Bool) {
        stickerCollection.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.customBackgroundColor()
        self.stickerCollection.delegate = self
        self.stickerCollection.dataSource = self
        
       
        initStickers()
        fetchNewColStickers("summer")
        
        let cellCollNib = UINib (nibName: "StickerViewCell", bundle: NSBundle.mainBundle())
        stickerCollection.registerNib(cellCollNib, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        
          initLayout()
          initToolBar()
         
       
    }
    
    func initStickers(){
        self.booklet["stickers"] = 16
        self.booklet["animals"] = 16
        self.booklet["summer"] = 12
        self.booklet["love"] = 16
        self.booklet["sakura"] = 16
    }
    
   // override func viewDidAppear(animated: Bool) {
    func initLayout(){
        let cellSize = (stickerCollection.collectionViewLayout.collectionViewContentSize().width / cellsPerRow ) - (cellSpacing)
        //layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        stickerCollection.collectionViewLayout = layout
    }
    func initToolBar(){
        let toolBar = UIToolbar(frame: CGRectMake(0,windowHeight - toolBarHeight, windowWidth, toolBarHeight))
        toolBar.barTintColor = UIColor.customBlueColor()
        toolBar.opaque = true
       //var doneButton = UIBarButtonItem(title: "animals", style: UIBarButtonItemStyle.Plain, target: self, action: "animals:")
       // var cancelButton = UIBarButtonItem(title: "sticker", style: UIBarButtonItemStyle.Plain, target: self, action: "stickers:")
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        var buttons =  [UIBarButtonItem] ()
        let keyArray = [String](booklet.keys)
        for i in 1...booklet.count{
            //var faction = keyArray[i-1] + ":"
            
            let faction = "updateStickerView:"
            
            let s = NSSelectorFromString(faction)
            let itemButton : StickerButton = StickerButton(type: .Custom)
            let imagename = keyArray[i-1] + "-1.png"
            itemButton.setImage(UIImage(named: imagename), forState: .Normal)
            itemButton.addTarget(self,action: s, forControlEvents: .TouchUpInside)
            itemButton.frame = CGRectMake(0,0,buttonSize, buttonSize)
            itemButton.name = keyArray[i-1]
            
            
            //let item = UIBarButtonItem(title: keyArray[i-1], style: UIBarButtonItemStyle.Plain, target: self, action: s)
            let item = UIBarButtonItem(customView: itemButton)
            
         
            buttons.append(item)
            buttons.append(spaceButton)
            print(keyArray[i-1])
            
            
        
        }
        
      
        //toolBar.setItems([doneButton, cancelButton], animated: false)
        toolBar.setItems(buttons, animated: false)
        toolBar.userInteractionEnabled = true
        
        
        
        
        //toolBar.addSubview(addButton)
        //toolBar.addSubview(viewButton)
        //toolBar.addSubview(settingButton)
        //toolBar.addSubview(favouriteButton)
        
        self.view.addSubview(toolBar)
        
       /* let scrollView = UIScrollView()
        scrollView.frame =  toolBar.frame
        scrollView.bounds = toolBar.bounds
        scrollView.autoresizingMask = toolBar.autoresizingMask
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false;
        
        let superView = toolBar.superview
        toolBar.removeFromSuperview()
        toolBar.autoresizingMask = UIViewAutoresizing.None
        toolBar.frame = CGRectMake(0, 0, 120, toolBar.frame.size.height)
        toolBar.bounds = toolBar.frame
        toolBar.setItems([cancelButton, doneButton], animated: false)
        scrollView.contentSize = toolBar.frame.size
        scrollView.addSubview(toolBar)
        superView?.addSubview(scrollView)
        
        */
        
        
        
        
        
        
        
    
    }
    func updateStickerView(barButtonItem: StickerButton ) {
        
        //let name = barButtonItem.image.
       
        fetchNewColStickers(barButtonItem.name)
        self.stickerCollection.reloadData()
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
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let pickedSticker = searches[indexPath.row]
        print(pickedSticker.name)
        //performSegueWithIdentifier("categoryMoments", sender: pickedSticker)  --> newmoment & s
        if let delegate = self.delegate {
            delegate.didPickSticker(self, stickerName: pickedSticker.name)
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = stickerCollection.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! StickerViewCell
        
        var imageView : UIImageView
      //  CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        //???????????????
        imageView = UIImageView (frame: CGRectMake(15,15, (stickerCollection.collectionViewLayout.collectionViewContentSize().width / cellsPerRow) - (cellSpacing + 30 ), (stickerCollection.collectionViewLayout.collectionViewContentSize().width / cellsPerRow) - (cellSpacing + 30)))
       //???????????????
     
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = searches[indexPath.row].image
        imageView.backgroundColor = UIColor.customBackgroundColor()
        //a serious bug here
        

        /*
        cell.imageItem = UIImageView(frame: CGRectMake(0,0, (stickerCollection.collectionViewLayout.collectionViewContentSize().width / cellsPerRow) - (cellSpacing ), (stickerCollection.collectionViewLayout.collectionViewContentSize().width / cellsPerRow) - (cellSpacing)))
       // cell.imageItem.contentMode = UIViewContentMode.ScaleAspectFit
       // cell.imageItem.image = searches[indexPath.row].image
        */
        
        
        
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
    /*func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        //UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        return UIEdgeInsetsMake(10, 10, windowHeight - toolBarHeight, 10)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(110, 110)
    }
*/
}
