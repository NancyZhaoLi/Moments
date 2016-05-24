//
//  UserSettingViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-02-18.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Firebase

class UserSettingViewController: UITableViewController {
    let ref = Firebase(url: "https://momentsxmen.firebaseio.com/")

    @IBOutlet weak var Trash_A: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
 //self.view.backgroundColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(224/255.0), alpha: 1.0)
        self.view.backgroundColor = UIColor(red: CGFloat(0.2), green: CGFloat(0.211765), blue: CGFloat(0.286275), alpha: 1.0)
        self.navigationController?.navigationBar.tintColor =  UIColor.whiteColor()
        // Do any additional setup after loading the view.
        Trash_A.text = String(getTrashAmount())
        print("user loaded")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Trash_A.text = String(getTrashAmount())
    }
    func getTrashAmount()->Int{
        let moments:[Moment] = CoreDataFetchHelper.fetchTrashedMomentsFromCoreData()
        return moments.count
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
         print("Selected session = \(indexPath.section)")
        print("Selected row = \(indexPath.row)")
        if indexPath.section == 2 && indexPath.row == 0 {
             let alertController = UIAlertController(title: "Rate Us!", message: "\nAre you enjoying our app? Please rate us in the app store!\n\nElse if you know of ways we can make our app better, please send us feedback so we can improve the experience for you!\n\nThanks!\nThe Moments Team", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Rate on iTunes", style: .Default, handler: { (action: UIAlertAction) in
                print("RateUs.RateUs_Tapped")

                print("Send to iTunes Monica")

                
               // let delayTime = dispatch_time(DISPATCH_TIME_NOW, <#T##delta: Int64##Int64#>)
                //dispatch_after( 5000000000, dispatch_get_main_queue()){
                
                UIApplication.sharedApplication().openURL(NSURL(string: "itunes.apple.com/app/id1093880482")!)
                //UIApplication.sharedApplication().openURL(NSURL(string: "itunes.apple.com/app/id959379869")!)
               // 959379869
                print("Done?")
                //UIApplication.sharedApplication().openURL(NSURL(string: "https://google.com")!)
                //alertController.dismissViewControllerAnimated(true, completion: nil)

                //}
            }))
            
            alertController.addAction(UIAlertAction(title: "No, Thanks!", style: .Default, handler: { (action: UIAlertAction) in
                print("RateUs.Cancel_Tapped")
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }))
             presentViewController(alertController, animated: true, completion: nil)
        
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Logout"{
            ref.unauth()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    

}
