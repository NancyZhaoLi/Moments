//
//  NewCategoryViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-06.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

protocol NewCategoryViewControllerDelegate {
    func newCategory(controller: NewCategoryViewController, category: CategoryEntry)
}

class NewCategoryViewController: UIViewController, UIViewControllerTransitioningDelegate, ColourPickerViewControllerDelegate {
    
    var delegate: NewCategoryViewControllerDelegate?
    
    @IBOutlet weak var categoryName: UITextField!

    @IBOutlet weak var categoryColour: UIButton!
    
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
        
        self.categoryColour.addTarget(self, action: "pickCategoryColour", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @IBAction func saveCategory(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.newCategory(self, category: getCategoryEntry())
        }
    }
    @IBAction func cancelNewCategory(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
   
    func pickCategoryColour() {
        let colourPickerVC: ColourPickerViewController = ColourPickerViewController(initialColour: categoryColour.backgroundColor, delegate: self)
        self.presentViewController(colourPickerVC, animated: true, completion: nil)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pickCategoryColour" {
            let colourPickerVC = segue.destinationViewController as! ColourPickerViewController
            colourPickerVC.delegate = self
        }
    }
    
    func getCategoryEntry() -> CategoryEntry {
        let name = categoryName.text!
        if let colour = categoryColour.backgroundColor {
            return CategoryEntry(colour: colour, name: name)
        }
        
        return CategoryEntry(colour: UIColor.whiteColor(), name: name)
    }
    
    
    
    // ColourPickerViewController Delegate
    func selectColor(controller: ColourPickerViewController, colour: UIColor) {
        controller.dismissViewControllerAnimated(false, completion: nil)
        categoryColour.backgroundColor = colour
        categoryColour.setTitle("", forState: .Normal)
    }
    
    func currentColor() -> UIColor {
        if let colour = categoryColour.backgroundColor {
            print("current color is: " + String(colour))
            return colour
        }
        
        return UIColor.whiteColor()
    }

}

