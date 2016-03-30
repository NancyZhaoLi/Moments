//
//  NewCategoryViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-03-06.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import SwiftHSVColorPicker

protocol NewCategoryViewControllerDelegate {
    func newCategory(controller: NewCategoryViewController, category: Category)
}

class NewCategoryViewController: UIViewController,
    UIViewControllerTransitioningDelegate, UITextFieldDelegate {
    
    var delegate: NewCategoryViewControllerDelegate?
    var categoryName: UITextField!
    var categoryColour: SwiftHSVColorPicker!
    var id: Int64?
    let titleMaxLength = 28

    convenience init() {
        self.init(delegate: nil)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(delegate: NewCategoryViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        setId()
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
        
        initUI()
    }
    
    func initUI() {
        self.view = UIView(frame: CGRectMake(0,0,windowWidth-20, windowHeight))
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.cornerRadius = 20.0
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOffset = CGSizeMake(0, 0)
        self.view.layer.shadowRadius = 10
        self.view.layer.shadowOpacity = 0.5
        
        let cancelButton = UIButton(frame: CGRectMake(15,28,60,30))
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        cancelButton.addTarget(self, action: "cancelNewCategory", forControlEvents: .TouchUpInside)
        
        let saveButton = UIButton(frame: CGRectMake(self.view.frame.width - 85, 28, 60, 30))
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        saveButton.addTarget(self, action: "saveNewCategory", forControlEvents: .TouchUpInside)
        
        let nameLabel = UILabel(frame: CGRectMake(20,85,60,30))
        nameLabel.text = "Name"
        nameLabel.textColor = UIColor.customGreenColor()
        
        let colourLabel = UILabel(frame: CGRectMake(20,145,60,30))
        colourLabel.text = "Colour"
        colourLabel.textColor = UIColor.customGreenColor()
        
        self.categoryName = UITextField(frame: CGRectMake(90,85,230,30))
        self.categoryName.layer.cornerRadius = 8.0
        self.categoryName.layer.borderWidth = 1.0
        self.categoryName.layer.borderColor = UIColor.customGreenColor().CGColor
        self.categoryName.delegate = self
        self.categoryName.spellCheckingType = .No
        self.categoryName.autocorrectionType = .No

        categoryColour = SwiftHSVColorPicker(frame: CGRectMake(20,200,self.view.frame.width - 65, self.view.frame.height - 200))
        categoryColour.setViewColor(UIHelper.randomBrightColour())
        
        self.view.addSubview(cancelButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(nameLabel)
        self.view.addSubview(colourLabel)
        self.view.addSubview(categoryColour)
        self.view.addSubview(categoryName)
    }
    
    func saveNewCategory() {
        if let delegate = self.delegate {
            if Category.categoryNameExist(categoryName: categoryName.text!) {
                
            
            } else {
                if let newCategory = getCategory() {
                    delegate.newCategory(self, category: newCategory)
                } else {
                    cancelNewCategory()
                }
            }
        }
    }
    
    func cancelNewCategory() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func setId() {
        if let maxIdInCD : Int64 = CoreDataFetchHelper.requestMaxCategoryId() {
            self.id = maxIdInCD + 1
        } else {
            self.id = 2
        }
    }
    
    func getCategory() -> Category? {
        let name = categoryName.text!
        if let colour = categoryColour.color {
            return Category(id: id!, colour: colour, name: name)
        }
        
        return Category(id: id!, colour: UIColor.customBlueColor(), name: name)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= titleMaxLength
    }

}

