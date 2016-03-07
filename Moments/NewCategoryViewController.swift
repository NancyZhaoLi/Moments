//
//  NewCategoryViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-06.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit


class NewCategoryViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var categoryName: UITextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
        
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 20.0
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(0, 0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
    }
    
    @IBAction func cancelNewCategory(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
   
    func presentationControllerForPresentedViewController(presented: UIViewController,
        presentingViewController presenting: UIViewController,
        sourceViewController source: UIViewController) -> UIPresentationController? {
            
            return CategoryPresentationController(presentedViewController: presented,
                presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController)-> UIViewControllerAnimatedTransitioning? {
        return CategoryPresentationAnimationController()
    }
    
    func getCategoryEntry() -> CategoryEntry {
        let name = categoryName.text!
        let colour = UIColor.redColor()
        
        return CategoryEntry(colour: colour, name: name)
    }
    
}

