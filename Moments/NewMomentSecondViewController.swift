//
//  NewMomentSavePageViewController.swift
//  
//
//  Created by Xin Lin on 2016-02-23.
//
//

import UIKit
import CoreData


extension NSDate {
    var month: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.stringFromDate(self)
    }
    var day: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(self)
    }
    var shortYear: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yy"
        return dateFormatter.stringFromDate(self)
    }
    var longYear: String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.stringFromDate(self)
    }
}

class NewMomentSecondViewController: UIViewController {
    
    var delegate : NewMomentViewController?
    var moment : MomentEntry?
    var momentDate : NSDate = NSDate()
    var momentTitle : String?
    var momentId : Int64?
    var momentIdPrefix : String?
    var context : NSManagedObjectContext?

    @IBOutlet weak var momentTitleDisplay: UITextField!
    
    @IBOutlet weak var momentCategoryDisplay: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.context = appDel.managedObjectContext
        
        self.momentCategoryDisplay.text = "Uncategorized"
        self.momentIdPrefix = self.momentDate.shortYear + self.momentDate.month + self.momentDate.day
        getDefaultTitle()
        getNewMomentId()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveMoment(sender: AnyObject) {
       self.moment = MomentEntry(id: self.momentId!, date: self.momentDate, title: self.momentTitle!)
        for subview in delegate!.view.subviews {
            print("view: ")
            print(subview)
        }
    }
        
    @IBAction func goBack(sender: AnyObject) {
        print("go back clicked")
        if let delegate = self.delegate {
            delegate.backFromSecondView()
        }
        
    }
    
    func comeFromFirstView() {
        delegate!.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func getDefaultTitle() {
        self.momentTitle = "Moment - " + self.momentDate.day + "/" + self.momentDate.month + "/" + self.momentDate.longYear
        self.momentTitleDisplay.text = self.momentTitle
    }
    
    func getNewMomentId() {
        let lastId : Int = getMaxId("Moment", type: nil)
        
        if (lastId >= 0) {
            self.momentId = Int64(self.momentIdPrefix! + String(format: "%04d", 0))
            print ("new momentId: " + String(self.momentId!))
        } else {
            print("failed to get new moment id")
        }
    }
    
    func getMaxId(entityName: String, type : String?) -> Int {
        var baseInt : Int64 = 0
        
        if (entityName == "Moment") {
            baseInt = Int64(self.momentIdPrefix! + "0000")!
        } else {
            if let itemType = type {
                if itemType == "Text" {
                    baseInt = Int64(self.momentIdPrefix! + "0000")!
                } else if itemType == "Image" {
                    baseInt = Int64(self.momentIdPrefix! + "1000")!
                } else if itemType == "Audio" {
                    baseInt = Int64(self.momentIdPrefix! + "2000")!
                } else if itemType == "Video" {
                    baseInt = Int64(self.momentIdPrefix! + "3000")!
                } else if itemType == "Sticker" {
                    baseInt = Int64(self.momentIdPrefix! + "4000")!
                }
            }
        }
        
        let request = NSFetchRequest(entityName: entityName)
        let sortDes = NSSortDescriptor(key: "id", ascending: false)
        
        request.sortDescriptors = [sortDes]
        request.predicate = NSPredicate(format: "id >= %lld", baseInt)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let results = try self.context!.executeFetchRequest(request)
            if results.count > 0 {
                let result = results[0] as! Int64
                if entityName == "Moment" {
                    return Int(result % 10000)
                } else {
                    return Int(result % 1000)
                }
            } else {
                print("no result for the fetch at " + entityName)
                return 0
            }
        } catch {
            print("ERROR: fetching failed")
        }
        
        return -1
    }
}
