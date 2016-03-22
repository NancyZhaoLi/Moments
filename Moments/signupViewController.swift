//
//  signupViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-21.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Firebase

class signupViewController: UIViewController, UITextFieldDelegate {
  let ref = Firebase(url: "https://momentsxmen.firebaseio.com/")
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var secondPassword: UITextField!
    @IBOutlet weak var firstPassword: UITextField!
    
    
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        if userEmail.text == "" || firstPassword.text == "" || secondPassword.text == "" {
            displayAlert("Error in form", message: "Please enter a username and password")
        
        }
        else if firstPassword.text != secondPassword.text {
            displayAlert("Password Doesn't Match", message: "Please reset your password")
        }
        else{
            ref.createUser(userEmail.text, password: firstPassword.text, withValueCompletionBlock: {
            (error, result) -> Void in
                
                if error != nil {
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                        case .EmailTaken:
                            self.displayAlert("Failed sign up", message: "The email address is already taken, please use another one")
                        case .InvalidEmail:
                            self.displayAlert("Failed sign up", message: "The specified email is not a valid email")
                        default:
                            self.displayAlert("Failed sign up", message: "An error has occured")
                        }
                    }
                    
                }
                
                else{
                
                    // after sign up, login
                    self.ref.authUser(self.userEmail.text, password: self.firstPassword.text, withCompletionBlock: { (error, authData) -> Void in
                        
                        if error != nil {
                            if let errorCode = FAuthenticationError(rawValue: error.code) {
                                switch (errorCode) {
                                case .InvalidEmail:
                                    self.displayAlert("Failed Login", message: "Invalid email address, please try again")
                                case .InvalidPassword:
                                    self.displayAlert("Failed Login", message: "Invalid password, please try again")
                                case .UserDoesNotExist:
                                    self.displayAlert("Failed Login", message: "User does not exists, please try again")
                                default:
                                    self.displayAlert("Failed Login", message: "An error has occured")
                                }
                            }
                            
                        } else {
                            let newUser = [
                                "provider": authData.provider,
                                "email": authData.providerData["email"] as? NSString as? String,
                                "name" : self.userName.text
                            ]
                            
                            // add a new user in database
                            self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                            
                            
                            self.performSegueWithIdentifier("SignupComplete", sender: self)
                            
                        }
                    })
                
                }
                
                
                
            })
        }
        
        
        
        
        
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
        self.userName.delegate = self
        self.userEmail.delegate = self
        self.secondPassword.delegate = self
        self.firstPassword.delegate = self

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
