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
    

    @IBAction func nancylink(sender: UIButton) {
           // if sender.
        if( sender.currentImage! == UIImage(named:"linkdin_f.png")){
        print(sender)
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.linkedin.com/in/nancy-zhao-ying-li-9b353496")!)
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
           
            
            
            // print("havn't added")
            UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/NancyZhaoLi")!)
           
        
        }
        
        
    }
    
     @IBAction func xinlink(sender: UIButton) {
    
        if( sender.currentImage! == UIImage(named:"linkdin_f.png")){
            print(sender)
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.linkedin.com/in/xin-lin-7a5872b5")!)
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
            
            
            
            // print("havn't added")
            UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/x58lin")!)
            
            
        }
    
    }
    
    
    
     @IBAction func emilylink(sender: UIButton) {
    
        if( sender.currentImage! == UIImage(named:"linkdin_f.png")){
            print(sender)
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.linkedin.com/in/yuning-xue-a5920a62")!)
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
            
            
            
            // print("havn't added")
            UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/xyuning")!)
            
            
        }
    
    }
    
    
    
     @IBAction func monicalink(sender: UIButton) {
    
        if( sender.currentImage! == UIImage(named:"twitter_f.png")){
            print(sender)
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/lalaphoon")!)
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
            
            
            
            // print("havn't added")
            UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/lalaphoon")!)
            
            
        }
    
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
