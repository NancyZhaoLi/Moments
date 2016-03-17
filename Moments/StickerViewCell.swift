//
//  CategoryViewCell.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-04.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class StickerViewCell: UICollectionViewCell {
    
   // @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var imageItem: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    
  /*  func constructName(categoryInfo: CategoryEntry) {
        
        name.text = categoryInfo.name
        name.textColor = UIColor.blackColor()
        name.frame = CGRect(x: 0, y: 10, width: self.frame.width, height: 30)
        name.font = UIFont(name: "Helvetica", size: 15.0)
        name.textAlignment = NSTextAlignment.Center
        name.lineBreakMode = NSLineBreakMode.ByWordWrapping
        name.numberOfLines = 0
        
    }*/
    
    
   /*
    func constructImageItem(categoryInfo: CategoryEntry) {
        
        imageItem.backgroundColor = categoryInfo.colour
        imageItem.frame = CGRect(x: 20, y: 40, width: self.frame.width - 40, height: self.frame.width - 40)
        
    }*/
    
    
    
    //Monica's functions
    /*func setCellName(name: String){
        print("setting name " + name)
        self.name.text = name
    }*/
    
    
    
    func setimage(item: UIImage){
        
        self.imageItem.image = item
    }
    
    
    
}
