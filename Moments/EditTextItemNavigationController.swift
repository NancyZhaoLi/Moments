//
//  EditTextItemNavigationController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-26.
//  Copyright © 2016 Moments. All rights reserved.
//

import Foundation
import UIKit

class EditTextItemNavigationController : UINavigationController {
    
    var viewDelegate: EditTextItemViewControllerDelegate?
    var text: String?
    var textAttribute: TextItemOtherAttribute?
    
    convenience init(){
        self.init(viewDelegate: nil, text: nil, textAttribute: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(viewDelegate: EditTextItemViewControllerDelegate?, text: String?, textAttribute: TextItemOtherAttribute?) {
        super.init(nibName: nil, bundle: nil)
        
        let editTextVC = EditTextItemViewController(delegate: viewDelegate, text: text, textAttribute: textAttribute)
        self.pushViewController(editTextVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}