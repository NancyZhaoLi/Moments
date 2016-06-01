//
//  personalSettingViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-11.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Firebase
class personalSettingViewController: UITableViewController  {

    
    
    let ref = Firebase(url: "https://momentsxmen.firebaseio.com/users")
    
    @IBOutlet weak var useremail: UILabel!
    
    @IBOutlet weak var username: UILabel!
    func showEmail (){
         print(ref.authData.uid)
     if ref.authData != nil {
        self.useremail.text = ref.authData.providerData["email"] as? String
        }
    }
    func showName(){
        if ref.authData != nil {
            
            print("showsth")
            
            var counter = 0
            ref.childByAppendingPath(ref.authData.uid)
                //.childByAppendingPath("name")
                .observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                    counter += 1
                    if counter == 2 {
                        print(snapshot.value)
                        self.username.text = snapshot.value as? String
                        
                    }
                    
                    }, withCancelBlock: { error in
                        print(error.description)
                })
  
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(0.2), green: CGFloat(0.211765), blue: CGFloat(0.286275), alpha: 1.0)
        showEmail()
        showName()
       
    }
    
   override func viewWillAppear(animated: Bool) {
     //showEmail()
    showName()
    super.viewWillAppear(animated)
       // print(ref.authData.providerData["email"])
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
