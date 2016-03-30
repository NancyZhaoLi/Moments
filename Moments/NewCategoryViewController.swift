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

protocol EditCategoryViewControllerDelegate {
    func editCategory(controller: NewCategoryViewController, categoryName: String, categoryColour: UIColor)
}

class NewCategoryViewController: UIViewController,
    UIViewControllerTransitioningDelegate, UITextFieldDelegate {
    
    var newCategoryDelegate: NewCategoryViewControllerDelegate?
    var editCategoryDelegate: EditCategoryViewControllerDelegate?
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
        self.newCategoryDelegate = delegate
        setId()
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
        
        initUI(nil, colour: nil)
    }
    
    init(delegate: EditCategoryViewControllerDelegate?, categoryName: String, categoryColour: UIColor) {
        super.init(nibName: nil, bundle: nil)
        self.editCategoryDelegate = delegate
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .Custom
        
        initUI(categoryName, colour: categoryColour)
    }
    
    func initUI(name: String?, colour: UIColor?) {
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
        
        categoryName = UITextField(frame: CGRectMake(90,85,230,30))
        categoryName.layer.cornerRadius = 8.0
        categoryName.layer.borderWidth = 1.0
        categoryName.layer.borderColor = UIColor.customGreenColor().CGColor
        categoryName.delegate = self
        categoryName.spellCheckingType = .No
        categoryName.autocorrectionType = .No
        categoryName.text = name

        categoryColour = SwiftHSVColorPicker(frame: CGRectMake(20,200,self.view.frame.width - 65, self.view.frame.height - 200))
        if let colour = colour {
            categoryColour.setViewColor(colour)
        } else {
            categoryColour.setViewColor(UIHelper.randomBrightColour())
        }
            
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
        view.addSubview(nameLabel)
        view.addSubview(colourLabel)
        view.addSubview(categoryColour)
        view.addSubview(categoryName)
    }

    func saveNewCategory() {
        if let delegate = self.editCategoryDelegate {
            checkForValidName()
            if let name = categoryName.text {
                let colour = categoryColour.color
                self.dismiss(true)
                delegate.editCategory(self, categoryName: name, categoryColour: colour)
            } else {
                cancelNewCategory()
            }
        } else if let delegate = self.newCategoryDelegate {
            checkForValidName()
            if let newCategory = getCategory() {
                self.dismiss(true)
                delegate.newCategory(self, category: newCategory)
            } else {
                cancelNewCategory()
            }
        }
    }
    
    private func checkForValidName() {
        if let categoryName = categoryName.text {
            let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
            if categoryName.isEmpty {
                showAlertForEmptyName()
            } else if categoryName.stringByTrimmingCharactersInSet(whitespaceSet).isEmpty {
                showAlertForAllSpaceName()
            } else if Category.categoryNameExist(categoryName: categoryName) {
                showAlertForDuplicateName()
            }
        } else {
            showAlertForEmptyName()
        }
    }
    
    private func showAlertForDuplicateName() {
        let alert = UIAlertController(title: "Category name already exist, enter a different name", message: nil, preferredStyle: .Alert)
        let okay = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Destructive, handler: nil)
        alert.addAction(okay)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func showAlertForEmptyName() {
        let alert = UIAlertController(title: "Category name cannot be empty, enter a name", message: nil, preferredStyle: .Alert)
        let okay = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Destructive, handler: nil)
        alert.addAction(okay)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func showAlertForAllSpaceName() {
        let alert = UIAlertController(title: "Category name cannot be all space, enter a different name", message: nil, preferredStyle: .Alert)
        let okay = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Destructive, handler: nil)
        alert.addAction(okay)
        presentViewController(alert, animated: true, completion: nil)
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

