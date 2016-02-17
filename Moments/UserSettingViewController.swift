//
//  UserSettingViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-02-16.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController {

    let ref = Firebase(url: "https://momentsxmen.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("user setting loaded")

       
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
@IBAction func Logout(sender: AnyObject) {
    ref.unauth()
    
    // Remove the user's uid from storage.
    
    //NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
    
    //https://www.youtube.com/watch?v=xhyc2jTVIHM
    self.dismissViewControllerAnimated(true, completion: nil)
    
   // self.performSegueWithIdentifier("logout", sender: self)
    
    //let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("login")
   // UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
    
    
    
        }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logout" {
            
         ref.unauth()
          NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
         //ref.authData = nil
            
        }
        
        
    }
*/
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
