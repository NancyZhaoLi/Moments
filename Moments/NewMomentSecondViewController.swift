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

    var idPrefix : String?
    var momentId : Int64?
    var textItemId : Int64?
    var imageItemId : Int64?
    var audioItemId : Int64?
    var videoItemId : Int64?
    var stickerItemId : Int64?
    
    var context : NSManagedObjectContext?

    @IBOutlet weak var momentTitleDisplay: UITextField!
    
    @IBOutlet weak var momentCategoryDisplay: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.context = appDel.managedObjectContext
        
        self.momentCategoryDisplay.text = "Uncategorized"
        self.idPrefix = self.momentDate.shortYear + self.momentDate.month + self.momentDate.day
        getDefaultTitle()
        getNewIds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveMoment(sender: AnyObject) {
        
        self.moment = MomentEntry(id: self.momentId!, date: self.momentDate, title: self.momentTitle!)
        for subview in delegate!.view.subviews {
            if let text = subview as? UITextView {
                print("view: text")
                print(subview)
                var item = ItemEntry(id: self.textItemId!, type: 0, frame: subview.frame)
                item.setContent(text.text)
                item.setOtherAttribute(text.textColor!, font: text.font!)
                self.textItemId = self.textItemId! + Int64(1)
            } else if let image = subview as? ImageItemViewController {
                print("view: image")
                print(subview)
                var item = ItemEntry(id: self.imageItemId!, type: 1, frame: image.frame)
                item.setContent(image.url!)
            }

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
    
    func getNewIds() {
        let lastId : Int = getMaxId("Moment", type: nil) + 1
        
        if (lastId >= 0) {
            self.momentId = Int64(self.idPrefix! + String(format: "%04d", lastId))
            print ("new momentId: " + String(self.momentId!))
        } else {
            print("failed to get new moment id")
        }
        
        self.textItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Text") + 1))
        print("textItemId: " + String(self.textItemId))
        self.imageItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Image") + 1))
        print("imageItemId: " + String(self.imageItemId))
        self.audioItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Audio") + 1))
        print("audioItemId: " + String(self.audioItemId))
        self.videoItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Video") + 1))
        print("videoItemId: " + String(self.videoItemId))
        self.stickerItemId = Int64(self.idPrefix! + String(format: "%05d", getMaxId("Item", type: "Sticker") + 1))
    }
    
    func getMaxId(entityName: String, type : String?) -> Int {
        var baseInt : Int64 = 0
        
        if (entityName == "Moment") {
            baseInt = Int64(self.idPrefix! + "0000")!
        } else {
            if let itemType = type {
                if itemType == "Text" {
                    baseInt = Int64(self.idPrefix! + "0000")!
                } else if itemType == "Image" {
                    baseInt = Int64(self.idPrefix! + "1000")!
                } else if itemType == "Audio" {
                    baseInt = Int64(self.idPrefix! + "2000")!
                } else if itemType == "Video" {
                    baseInt = Int64(self.idPrefix! + "3000")!
                } else if itemType == "Sticker" {
                    baseInt = Int64(self.idPrefix! + "4000")!
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
                return -1
            }
        } catch {
            print("ERROR: fetching failed")
        }
        
        return -2
    }
}
