//
//  feedbackViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-07.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import MessageUI

class feedbackViewController: UIViewController,MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var subject: UITextField!
    
    
    @IBOutlet weak var content: UITextView!
    
    
    @IBAction func sendEmail(sender: AnyObject) {
        print("button is pressed")
        
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
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
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        print("self is")
        print(self)
        mailComposerVC.setToRecipients(["lalaphoon@hotmail.ca"])
        //mailComposerVC.setSubject("Moments Feedback")
        mailComposerVC.setSubject(subject.text!)
        mailComposerVC.setMessageBody("Hi Moments Team!\n\nI would like to share the following feedback..\n" + content.text!, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        print("I'm here")
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",preferredStyle: UIAlertControllerStyle.Alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        
        
        
        
        
        
        /* let alert = UIAlertController(title: "Save Video", message: "Your video has been saved!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))*/
        
        
        
    }
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        switch result.rawValue {
            
        case MFMailComposeResultCancelled.rawValue:
            print("Cancelled mail")
            
            let alert = UIAlertController(title: "Sending Cancelled", message: "You have cancelled sending your email!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            // alert.viewDidAppear( true)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        case MFMailComposeResultSent.rawValue:
            print("Mail Sent")
            let alert = UIAlertController(title: "Mail Sent", message: "Your email has been sent to us!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            // alert.viewDidAppear( true)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        case MFMailComposeResultSaved.rawValue:
            print("You saved a draft of this email")
            break;
            
        default:
            break
        }
        
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.content.delegate = self
        self.subject.delegate = self
        
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

