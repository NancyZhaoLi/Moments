//
//  CategoryEntry.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-22.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class CategoryEntry {
    //let id: Int64

    var colour: UIColor = UIColor.blueColor()
    var name: String
    var momentEntries = [MomentEntry]()
    
    //init(id: Int64) {
    init() {
        //self.id = id
        self.colour = UIColor.blueColor()
        self.name = "Uncategorized"
    }
    
    init(categoryMO: Category) {
        //self.id = categoryMO.id!.longLongValue
        self.colour = categoryMO.colour as! UIColor
        self.name = categoryMO.name!
        
        for momentMO in categoryMO.containedMoment! {
            let moment = MomentEntry(momentMO: momentMO as! Moment)
            addMoment(moment)
        }
    }
    
 
    //init(id: Int64, colour: UIColor, name: String) {
    init(colour: UIColor, name: String) {
        //self.id = id
        self.colour = colour
        self.name = name
    }
    
    func setColour(colour: UIColor) {
        self.colour = colour
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func addMoment(moment: MomentEntry) {
        momentEntries.append(moment)
    }
    
}