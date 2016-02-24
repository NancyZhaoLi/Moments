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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("home loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        if let NewMomentSavePageVC = segue.sourceViewController as? NewMomentSavePageViewController {
            
            if let moment: MomentEntry = NewMomentSavePageVC.getMomentEntry() {
                saveNewMomentToCoreData(moment)
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
        let textItemEntries: [TextItemEntry] = moment.textItemEntries
        let imageItemEntries: [ImageItemEntry] = moment.imageItemEntries
        let audioItemEntries: [AudioItemEntry] = moment.audioItemEntries
        let videoItemEntries: [VideoItemEntry] = moment.videoItemEntries
        let stickerItemEntries: [StickerItemEntry] = moment.stickerItemEntries
        //let category: CategoryEntry = moment.category!
        
        newMomentEntity.setValue(backgroundColour, forKey: "backgroundColour")
        newMomentEntity.setValue(date, forKey: "date")
        newMomentEntity.setValue(favourite, forKey: "favourite")
        newMomentEntity.setValue(NSNumber(longLong: id), forKey: "id")
        newMomentEntity.setValue(title, forKey: "title")
        newMomentEntity.setValue(NSSet(array: textItemEntries), forKey: "containedTextItem")
        newMomentEntity.setValue(NSSet(array: imageItemEntries), forKey: "containedImageItem")
        newMomentEntity.setValue(NSSet(array: audioItemEntries), forKey: "containedAudioItem")
        newMomentEntity.setValue(NSSet(array: videoItemEntries), forKey: "containedVideoItem")
        newMomentEntity.setValue(NSSet(array: stickerItemEntries), forKey: "containedStickerItem")
        //newMomentEntity.setValue(category, forKey: "inCategory")
        
        // save it
        do{
            try context.save()
        } catch {
            print("ERROR: saving context to Moment")
        }
        
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
