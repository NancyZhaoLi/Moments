//
//  privacyViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-11.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Firebase

class privacyViewController: UIViewController, UITextFieldDelegate {
    
    let ref = Firebase(url: "https://momentsxmen.firebaseio.com/")
    //var authData
    var useremail = ""
    var userpass = ""
    

    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
           //Nothing:
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func displaylogoutAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //self.ref.unauth()
            //self.dismissViewControllerAnimated(true, completion: nil)
            self.logout()
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    @IBOutlet weak var newpassword: UITextField!
    @IBOutlet weak var oldpassword: UITextField!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: CGFloat(0.2), green: CGFloat(0.211765), blue: CGFloat(0.286275), alpha: 1.0)
        self.newpassword.delegate = self
        self.oldpassword.delegate = self
        
        if ref.authData != nil{
         
            print(ref.authData)
            print(ref.authData.providerData["email"]!)
            useremail = ref.authData.providerData["email"] as! String
            //print(ref.authData.providerData["password"]!)
            print(ref.authData.provider)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeEmailForUser(sender: AnyObject) {
    
    }

    @IBAction func ChangePasswordForUser(sender: AnyObject) {
        if oldpassword.text == "" || newpassword.text == "" {
        displayAlert("Error in form", message: "Please enter your old password or new password")
        
        
        }
   
        else{
        if oldpassword.text != nil && newpassword.text != nil {
            ref.changePasswordForUser(useremail, fromOld: oldpassword.text, toNew: newpassword.text, withCompletionBlock:  { error in
                if error != nil {
                    if let errorCode = FAuthenticationError(rawValue: error.code){
                        switch(errorCode){
                        case .InvalidPassword:
                            self.displayAlert("Failed Changing Password", message: "Old password is incorrect , please type the correct old password")
                        default:
                            self.displayAlert("Failed Mission", message: "An error has occured")
                        }
                    }
                } else {
                    print("successly changed the password, please logout")
                    
                    self.displaylogoutAlert("Succeed!", message:"You have successfully changed your password. Please re-login!")
                    
                    //self.logout()
                    
                    
                    // Password changed successfully
                }} )
        
            }
        }
       
    
    }

   /* @IBAction func ResetPasswordForUser(sender: AnyObject) {
        self.sendPasswordResetForUser()
        
    }

    func sendPasswordResetForUser(){
        ref.resetPasswordForUser(useremail, withCompletionBlock: {error in
            if error != nil {
                print(error)
            
            }else{
               print("sending reset password reuqest")
            }
            }
        )
    
    
    }*/
    

        // close keyboard when touches began
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    // close keyboard when press return button
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    func logout(){
    
        ref.unauth()
        self.dismissViewControllerAnimated(true, completion: nil)
    
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
