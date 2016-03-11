//
//  resetpasswordViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-11.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Firebase

class resetpasswordViewController: UIViewController,UITextFieldDelegate {
 let ref = Firebase(url: "https://momentsxmen.firebaseio.com/")
   
    
    @IBOutlet weak var email: UITextField!
    
    @IBAction func resetPassword(sender: AnyObject) {
        if email.text != nil {
          self.sendPasswordResetForUser()
          //self.displayAlert("Email Sent!", message: "Please check back email!")
        
        }
        
        
    }
    
    @IBAction func nothinghappen(sender: AnyObject) {
        
       // navigationController?.popToRootViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    func displayOkAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    func sendPasswordResetForUser(){
        ref.resetPasswordForUser(email.text!, withCompletionBlock: {error in
            if error != nil {
                
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .InvalidEmail:
                        self.displayAlert("Invald Email", message: "Invalid email address, please try again")
                    case .UserDoesNotExist:
                        self.displayAlert("Incorrect Login", message: "User does not exists, please try again")
                    default:
                        self.displayAlert("Failed Login", message: "An error has occured")
                    }
                }
               
                
            }else{
               self.displayOkAlert("Email Sent!", message: "Please Check Email!")
              }
            }
        )
        
        
    }
    // close keyboard when touches began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    // close keyboard when press return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email.delegate = self

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
