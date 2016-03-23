//
//  CategoryIdIndexEntry.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-23.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class CategoryIdIndexEntry {

    var idToIndex = NSMapTable()
    var indexToId = NSMapTable()
    
    init(idToIndex: NSMapTable, indexToId: NSMapTable) {
        self.idToIndex = idToIndex
        self.indexToId = indexToId
    }
    
    init(categoryIdIndexMO: CategoryIdIndex) {
        idToIndex = categoryIdIndexMO.idToIndex as! NSMapTable
        indexToId = categoryIdIndexMO.indexToId as! NSMapTable
    }
    
    func addIdToIndexPair(key: Int, value: Int) {
        idToIndex.setObject(value, forKey: key)
    }
    
    func addIndexToIdPair(key: Int, value: Int) {
        indexToId.setObject(value, forKey: key)
    }
    
}
