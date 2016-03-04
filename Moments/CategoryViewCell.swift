//
//  CategoryViewCell.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-04.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    
    @IBOutlet  var name: UILabel!
    
    @IBOutlet  var imageItem: UIImageView!
    
    //var backgroundcolor: UIColor
    
    /* init(){
    
    self.backgroundcolor = UIColor.clearColor()
    
    }*/
    
    
    
    func setCellName(name: String){
        print("setting name " + name)
        self.name.text = name
    }
    
    func setimage(item: UIImage){
        
        self.imageItem.image = item
    }

    
    
    
    
    
    
    
    
    
    
  /*  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }*/
    
    
    
    

}
