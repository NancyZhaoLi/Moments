//
//  HomeViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-02-18.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var momentsMO = [NSManagedObject]()
    var moments = [MomentEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("home loaded")
        getMomentsMOFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        if let NewMomentSavePageVC = segue.sourceViewController as? NewMomentSavePageViewController {
            
            if let moment: MomentEntry = NewMomentSavePageVC.getMomentEntry() {
                saveNewMomentToCoreData(moment)
                moments.append(moment)
                reloadMomentsMOFromCoreData()
            }
        }
    }
    
    func saveNewMomentToCoreData(moment:MomentEntry) {
        print("saveNewMoment")
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let newMomentEntity = NSEntityDescription.insertNewObjectForEntityForName("Moment", inManagedObjectContext: context) as! Moment
        
        let backgroundColour: UIColor = moment.backgroundColour
        let date: NSDate  = moment.date
        let favourite: Bool = moment.favourite
        let id: Int64 = moment.id
        let title: String = moment.title
        //let textItemEntries: [TextItemEntry] = moment.textItemEntries
        //let imageItemEntries: [ImageItemEntry] = moment.imageItemEntries
        //let audioItemEntries: [AudioItemEntry] = moment.audioItemEntries
        //let videoItemEntries: [VideoItemEntry] = moment.videoItemEntries
        //let stickerItemEntries: [StickerItemEntry] = moment.stickerItemEntries
        //let category: CategoryEntry = moment.category!
        
        newMomentEntity.setValue(backgroundColour, forKey: "backgroundColour")
        newMomentEntity.setValue(date, forKey: "date")
        newMomentEntity.setValue(favourite, forKey: "favourite")
        newMomentEntity.setValue(NSNumber(longLong: id), forKey: "id")
        newMomentEntity.setValue(title, forKey: "title")
        //newMomentEntity.setValue(NSSet(array: textItemEntries), forKey: "containedTextItem")
        //newMomentEntity.setValue(NSSet(array: imageItemEntries), forKey: "containedImageItem")
        //newMomentEntity.setValue(NSSet(array: audioItemEntries), forKey: "containedAudioItem")
        //newMomentEntity.setValue(NSSet(array: videoItemEntries), forKey: "containedVideoItem")
        //newMomentEntity.setValue(NSSet(array: stickerItemEntries), forKey: "containedStickerItem")
        //newMomentEntity.setValue(category, forKey: "inCategory")
        
        // save it
        do{
            try context.save()
        } catch {
            print("ERROR: saving context to Moment")
        }
        
    }
    
    func getMomentsMOFromCoreData(){
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(requestMoments) as? [NSManagedObject]
            momentsMO = results!
            
            for var i = 0; i < momentsMO.count; ++i {
                addMomentFromCoreData(momentsMO[i])
            }
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
    func reloadMomentsMOFromCoreData(){
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext =  appDel.managedObjectContext
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.returnsObjectsAsFaults = false
        
        do {
            let results = try context.executeFetchRequest(requestMoments) as? [NSManagedObject]
            momentsMO = results!
            
        } catch {
            fatalError("Failure to fetch context: \(error)")
        }
        
    }
    
    func addMomentFromCoreData(momentMO: NSManagedObject) {
        let id =  momentMO.valueForKey("id")?.longLongValue
        let date = momentMO.valueForKey("date") as? NSDate
        let title = momentMO.valueForKey("title") as? String
        let moment = MomentEntry(id: id!, date: date!, title: title!)
        moments.append(moment)
        print("id: \(id!), date: \(date!), title: \(title!)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
