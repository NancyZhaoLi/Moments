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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("user loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*@IBAction func Logout(sender: AnyObject) {
        ref.unauth()
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }*/
    
    
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
