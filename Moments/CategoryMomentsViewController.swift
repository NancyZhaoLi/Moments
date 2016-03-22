//
//  CategoryMomentsViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-05.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit


class CategoryMomentsViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var momentsTableView: UITableView!
    
    
    var category: CategoryEntry?
    
    var moments = [MomentEntry]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCategoryNameLabel()
        getMomentsInCategory()
        print(moments.count)
        
        // Do any additional setup after loading the view.
        let cellNib = UINib(nibName: "MomentTableCell", bundle: NSBundle.mainBundle())
        momentsTableView.registerNib(cellNib, forCellReuseIdentifier: "MomentTableCell")
        
        self.momentsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.momentsTableView.showsVerticalScrollIndicator = false
        self.momentsTableView.backgroundColor = UIColor.clearColor()
        
        self.view.backgroundColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(246/255.0), alpha: 1.0)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSavedMoment" {
            let newMomentNavigationVC = segue.destinationViewController as! NewMomentNavigationController
            let newMomentCanvasVC = newMomentNavigationVC.topViewController as! NewMomentCanvasViewController
            let cell = sender as! MomentTableCell
            newMomentCanvasVC.loadedMoment = cell.moment
        }
    }
    
    func updateCategoryNameLabel() {
        categoryName.text = category?.name
        
    }

    func getMomentsInCategory() {
        for moment in (category?.momentEntries)! {
            print("moment in category")
            moments.append(moment)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = momentsTableView.dequeueReusableCellWithIdentifier("MomentTableCell", forIndexPath: indexPath) as! MomentTableCell
        
        cell.frame.size.width = self.momentsTableView.frame.width
        cell.moment = moments[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        
        return cell

    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (moments[indexPath.row].imageItemEntries.count > 0) {
            return 185
        }
        return 120
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.momentsTableView.cellForRowAtIndexPath(indexPath) as! MomentTableCell
        print("cell at \(indexPath.row) is clicked")
        //self.indexOfCellClicked = indexPath.row
        performSegueWithIdentifier("editSavedMoment", sender: cell)
    }



    
}