//
//  resetNameViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Firebase

class resetNameViewController: UIViewController, UITextFieldDelegate {
    let ref = Firebase(url: "https://momentsxmen.firebaseio.com/")
    
    
    @IBOutlet weak var username: UITextField!
    
    
    @IBAction func changUserName(sender: AnyObject) {
        if ref.authData != nil {
            self.changename()
            self.displayAlert("Changed Name Successfully", message: "You have successfully changed your name!")
            
        }
    }
    //func displayAlert()
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //Nothing:
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func changename(){
        
        let currentuid =  ref.authData.uid as? String
        //let URL_F = "https://momentsxmen.firebaseio.com/users/" + ref.authData.uid
        //let reff = Firebase(url: URL_F)
        let reff = ref.childByAppendingPath("users").childByAppendingPath(currentuid)
        let newname = self.username.text as String!
        var changedname = ["name" : newname]
        reff.updateChildValues(changedname)
        showName()
        
        
    }
    func showName(){
        if ref.authData != nil {
            
            print("showsth-right here")
            
            var counter = 0
            ref.childByAppendingPath("users")
                .childByAppendingPath(ref.authData.uid)
                //.childByAppendingPath("name")
                .observeEventType(.ChildAdded, withBlock: { snapshot in
                    //print("printing updated name now")
                    // print(snapshot.value)
                    counter += 1
                    if counter == 2 {
                        print("reset successful")
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
        self.view.backgroundColor = UIColor.customBlueColor()
        self.hideKeyboardWhenTappedAround()
        showName()
        
        
        // Do any additional setup after loading the view.
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
