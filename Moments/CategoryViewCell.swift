//
//  CategoryViewCell.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-04.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var imageItem: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var category: CategoryEntry? {
        didSet {
            constructCategoryCell()
        }
    }
    
    func constructCategoryCell() {
        if let categoryInfo = category {
            constructName(categoryInfo)
            constructImageItem(categoryInfo)
            
        }
    }
    
    
    func constructName(categoryInfo: CategoryEntry) {
        
        name.text = categoryInfo.name
        name.textColor = UIColor(white: 0.0, alpha: 0.7)
        name.backgroundColor = UIColor.clearColor()
        name.frame = CGRect(x: 0, y: 46, width: self.frame.width, height: 30)
        name.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        name.textAlignment = NSTextAlignment.Center
        name.lineBreakMode = NSLineBreakMode.ByWordWrapping
        name.numberOfLines = 0
        
    }
    
    func constructImageItem(categoryInfo: CategoryEntry) {
        
        imageItem.backgroundColor = categoryInfo.colour
        imageItem.frame = CGRect(x: 20, y: 20, width: self.frame.width - 40, height: self.frame.width - 40)
        
    }
    
    //Monica's functions
    func setCellName(name: String){
        print("setting name " + name)
        self.name.text = name
    }
    
    func setimage(item: UIImage){
        
        self.imageItem.image = item
    }

    

}
