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
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // delete category cells
    var deleting: Bool = false {
        
        didSet {
            selectedImage.hidden = !deleting
        }
    }
    
    override var selected: Bool {
        
        didSet {
            if deleting {
                selectedImage.image = UIImage(named: selected ? "selected" : "unselected")
            }
        }
    }
    
    // moving category cells
    var draging: Bool = false {
        
        didSet {
            let alpha: CGFloat = draging ? 0.0 : 1.0
            imageItem.alpha = alpha
            name.alpha = alpha
        }
    }
    
    var categorySnapshot: UIView {
        
        get {
            let categorySnapshot = snapshotViewAfterScreenUpdates(true)
            let layer = categorySnapshot.layer
            
            layer.shadowOffset = CGSize(width: -3.0, height: 3.0)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 6.0
            layer.masksToBounds = false
            
            return categorySnapshot
        }
    }
    
    // categoryEntry for constructing the cell
    var category: CategoryEntry? {
        
        didSet {
            constructCategoryCell()
        }
    }
    
    func constructCategoryCell() {
        
        if let categoryInfo = category {
            constructName(categoryInfo)
            constructImageItem(categoryInfo)
            constructSelectedImage()
        }
    }
    
    
    func constructName(categoryInfo: CategoryEntry) {
        
        name.text = categoryInfo.name
        name.textColor = UIColor(white: 0.0, alpha: 0.7)
        name.backgroundColor = UIColor.clearColor()
        name.frame = CGRect(x: 0, y: self.frame.width / 2 - 15, width: self.frame.width, height: 30)
        name.font = UIFont(name: "Helvetica-Bold", size: 15.0)
        name.textAlignment = NSTextAlignment.Center
        name.lineBreakMode = NSLineBreakMode.ByWordWrapping
        name.numberOfLines = 0
        
    }
    
    func constructImageItem(categoryInfo: CategoryEntry) {
        
        imageItem.backgroundColor = categoryInfo.colour
        imageItem.frame = CGRect(x: 20, y: 20, width: self.frame.width - 40, height: self.frame.width - 40)
        
    }
    
    func constructSelectedImage() {
        selectedImage.frame = CGRect(x: (self.frame.width / 2) - 10, y: self.frame.width - 43, width: 20, height: 20)
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
