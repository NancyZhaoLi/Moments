//
//  aboutusViewController.swift
//  
//
//  Created by Mengyi LUO on 2016-03-10.
//
//

import UIKit
import SafariServices

class aboutusViewController: UIViewController,SFSafariViewControllerDelegate
{

    override func viewDidLoad() {
        super.viewDidLoad()
         print("setting view loaded")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //icons from: https://dribbble.com/shots/2421400-Social-icons
    
    //let safari = UIApplication.sharedApplication()
    func openSafari(userUrl : String){
        let svc = SFSafariViewController(URL: NSURL(string: userUrl)!)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
    
    }

    @IBAction func nancylink(sender: UIButton) {
        
        if( sender.currentImage! == UIImage(named:"linkdin_f.png")){
    
            openSafari("https://www.linkedin.com/in/nancy-zhao-ying-li-9b353496")
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
       
            openSafari("https://github.com/NancyZhaoLi")
         }
       
    }
    
  
     @IBAction func xinlink(sender: UIButton) {
    
        if( sender.currentImage! == UIImage(named:"linkdin_f.png")){
            print(sender)
         
            openSafari("https://www.linkedin.com/in/xin-lin-7a5872b5")
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
          
            openSafari("https://github.com/x58lin")
            
            
        }
       
        //aboutusViewController.dismissViewControllerAnimated(true, completion: nil)
        //self.aboutusViewController.dismissViewControllerAnimated(true, completion: nil)
        //self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    
     @IBAction func emilylink(sender: UIButton) {
    
        if( sender.currentImage! == UIImage(named:"linkdin_f.png")){
            print(sender)
         
            openSafari("https://www.linkedin.com/in/yuning-xue-a5920a62")
            
            
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
            
            openSafari("https://github.com/xyuning")
            
        }
   
    }
    
    
    
     @IBAction func monicalink(sender: UIButton) {
    
        if( sender.currentImage! == UIImage(named:"twitter_f.png")){
           
            openSafari("https://twitter.com/lalaphoon")
          
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
            
            openSafari("https://github.com/lalaphoon")
            
            
        }
 
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
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
