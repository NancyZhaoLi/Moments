//
//  ViewController.swift
//  Moments
//
//  Created by Yuning (Emily) Xue on 2016-02-13.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    let ref = Firebase(url: "https://momentsxmen.firebaseio.com/")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if ref.authData != nil {
            print("there is a user already signed in")
            
            // TODO: if a user already signed in, skip the login process,
            // go to login complete page
        //self.performSegueWithIdentifier("loginAndSignUpComplete", sender: self)
            
        } else {
            print("you will have to login or sign up")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(sender: AnyObject) {
        
        if emailTextField == "" || passwordTextField.text == "" {
            print("Please fill in all fields")
            
        } else {
            ref.authUser(emailTextField.text, password: passwordTextField.text, withCompletionBlock: { (error, authData) -> Void in
                
                if error != nil {
                    print(error)
                    print("There is an error with the given information")
                    
                } else {
                    print("login success!")
                    
                    // TODO: if login success, go to login complete page
                    //self.performSegueWithIdentifier("loginAndSignUpComplete", sender: self)
                
                }
            })
        }
    
    }
    
    @IBAction func signUp(sender: AnyObject) {
        if emailTextField == "" || passwordTextField.text == "" {
            print("Please fill in all fields")
        } else {
            ref.createUser(emailTextField.text, password: passwordTextField.text, withValueCompletionBlock: { (error, result) -> Void in
                
                if error != nil {
                    print(error)
                } else {
                    print("success sign up!")
                    
                    // after sign up, login
                    self.ref.authUser(self.emailTextField.text, password: self.passwordTextField.text, withCompletionBlock: { (error, authData) -> Void in
                        
                        if error != nil {
                            print(error)
                            print("There is an error with the given information")
                            
                        } else {
                            let newUser = [
                                "provider": authData.provider,
                                "email": authData.providerData["email"] as? NSString as? String
                            ]
                            
                            // add a new user in database
                            self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                            
                            // TODO: login success, go to login complete page
                            //self.performSegueWithIdentifier("loginAndSignUpComplete", sender: self)
                            
                        }
                    })
                    
                }
            })
        }
    }
    

}

