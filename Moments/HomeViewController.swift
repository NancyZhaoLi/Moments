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
        getMomentsFromCoreData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHomeView(segue: UIStoryboardSegue) {
        if let NewMomentSavePageVC = segue.sourceViewController as? NewMomentSavePageViewController {
            
            if let moment: MomentEntry = NewMomentSavePageVC.getMomentEntry() {
                CoreDataSaveHelper.saveNewMomentToCoreData(moment)
                moments.append(moment)
                reloadMomentsMOFromCoreData()
            }
        }
    }
    
    
    func getMomentsFromCoreData(){
        
        var momentsMO: [NSManagedObject] = CoreDataFetchHelper.fetchMomentsMOFromCoreData()
            
        for var i = 0; i < momentsMO.count; ++i {
            addMomentFromCoreData(momentsMO[i])
        }
        
    }
    
    func reloadMomentsMOFromCoreData(){
        
        let requestMoments = NSFetchRequest(entityName: "Moment")
        requestMoments.returnsObjectsAsFaults = false
        
        do {
            let results = try CoreDataFetchHelper.context!.executeFetchRequest(requestMoments) as? [NSManagedObject]
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
