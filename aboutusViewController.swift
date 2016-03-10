//
//  aboutusViewController.swift
//  
//
//  Created by Mengyi LUO on 2016-03-10.
//
//

import UIKit

class aboutusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func monicalink(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.linkedin.com/in/nancy-zhao-ying-li-9b353496")!)
        
        
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
