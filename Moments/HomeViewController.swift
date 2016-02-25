//
//  HomeViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-02-18.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate {
    
    var content = ["Rob", "K", "E"]
    var momentsMO = [Moment]()
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
                getMomentsMOFromCoreData()
            }
        }
    }
    
    
    func getMomentsFromCoreData(){
        
        getMomentsMOFromCoreData()
            
        for var i = 0; i < momentsMO.count; ++i {
            addMomentFromCoreData(momentsMO[i])
        }
        
    }
    
    func getMomentsMOFromCoreData(){
        momentsMO = CoreDataFetchHelper.fetchMomentsMOFromCoreData()
    }
    
    func addMomentFromCoreData(momentMO: Moment) {
        let id =  momentMO.id?.longLongValue
        let date = momentMO.date
        let title = momentMO.title
        let moment = MomentEntry(id: id!, date: date!, title: title!)
        //moment.setBackgroundColour(momentMO.backgroundColour)
        moments.append(moment)
        print("id: \(id!), date: \(date!), title: \(title!)")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = content[indexPath.row]
        
        return cell
    }

}
