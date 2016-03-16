//
//  StickerItemManager.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-09.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class StickerItemManager : ItemManager {
    
    var stickerItems : [StickerItemViewController] = [StickerItemViewController]()
    
    override init() {
        super.init()
        super.type = ItemType.Text
        super.debugPrefix = "[TextItemManager] - "
    }
    
    func loadSticker(stickerItem: StickerItemEntry) -> StickerItemViewController {
        return StickerItemViewController()
    }
    
    override func setEditMode(editMode: Bool) {
        for textItem in stickerItems {
            textItem.view.userInteractionEnabled = editMode
        }
    }
    
}