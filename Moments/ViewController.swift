//
//  ViewController.swift
//  Moments
//
//  Created by Yuning (Emily) Xue on 2016-02-18.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let ref = Firebase(url: "https://momentsxmen.firebaseio.com/")
    
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        if ref.authData != nil {
            print("there is a user already signed in")
            
            // TODO: if a user already signed in, skip the login process,
            // go to login complete page
            
            self.performSegueWithIdentifier("loginAndSignUpComplete", sender: self)
            
            
        } else {
            print("you will have to login or sign up")
            
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if emailTextField == "" || passwordTextField.text == "" {
            displayAlert("Error in form", message: "Please enter a username and password")
            
        } else {
            ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: { (error, authData) -> Void in
                
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
                    print("login success!")
                    
                    // TODO: if login success, go to login complete page
                    self.performSegueWithIdentifier("loginAndSignUpComplete", sender: self)
                    
                    
                }
            })
        }
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if emailTextField == "" || passwordTextField.text == "" {
            displayAlert("Error in form", message: "Please enter a username and password")
            
        } else {
            ref.createUser(emailTextField.text, password: passwordTextField.text, withValueCompletionBlock: { (error, result) -> Void in
                
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
                    
                } else {
                    
                    // after sign up, login
                    self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: { (error, authData) -> Void in
                        
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
                                "email": authData.providerData["email"] as? NSString as? String
                            ]
                            
                            // add a new user in database
                            self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                            
                            // TODO: login success, go to login complete page
                            self.performSegueWithIdentifier("loginAndSignUpComplete", sender: self)
                            
                            
                        }
                    })
                    
                }
            })
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

