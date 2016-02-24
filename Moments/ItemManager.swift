//
//  ItemVCManager.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import CoreData

struct ItemTypeInfo {
    let IDPrefix : String
    let entityName : String
    
    init(prefix: String, entity: String) {
        self.IDPrefix = prefix
        self.entityName = entity + "Item"
    }
}


enum ItemType: String {
    case Text = "Text",
         Image = "Image",
         Audio = "Audio",
         Video = "Video",
         Sticker = "Sticker"
    
    var idPrefix : String { return String(self.hashValue + 1) }
    var entity : String { return self.rawValue + "Item" }
    static var baseId : String { return "000" }
    static var modValue : Int64 { return 1000 }
}



class ItemManager {
    var canvas : NewMomentCanvasViewController?
    var superManager : NewMomentManager?
    var idPrefix : String = ""
    var testMode: Bool = true
    var debugPrefix : String = "[ItemManager] - "
    var type : ItemType = ItemType.Text
    var idSuffix : String = ""
    
    init() {}
    
    func setCanvasAndManager(canvas: NewMomentCanvasViewController, manager : NewMomentManager, idPrefix: String){
        self.canvas = canvas
        self.superManager = manager
        self.idPrefix = idPrefix + self.type.idPrefix
        self.idSuffix = getMaxIdInCoreData()
    }
    
    func getMaxIdInCoreData() -> String {
        if let maxIdInCD : Int64 = superManager!.requestMaxOfIdGreaterThan(Int64(self.idPrefix)!, entity: self.type.entity) {
            return String(format: "%04lld", maxIdInCD)
        } else {
            return "000"
        }
    }
    
    func getId() -> Int64 {
        let id = Int64(self.idPrefix + self.idSuffix)!
        debug("[getId] - id: " + String(id))
        return id
    }
    
    func notifySaveMoment(){
        saveAllItemEntry()
    }

    func saveAllItemEntry(){}
    
    func debug (msg: String) {
        if (self.testMode) {
            print(self.debugPrefix + msg)
        }
    }
    
    func debugBegin(fn: String) {
        if (self.testMode) {
            print(self.debugPrefix + "[" + fn + "] - begin")
        }
    }
    
    func debugEnd(fn: String) {
        if (self.testMode) {
            print(self.debugPrefix + "[" + fn + "] - end")
        }
    }
}
