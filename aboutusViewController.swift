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
    

    @IBAction func nancylink(sender: UIButton) {
        
        if( sender.currentImage! == UIImage(named:"linkdin_f.png")){
       
         //safari.openURL(NSURL(string: "https://www.linkedin.com/in/nancy-zhao-ying-li-9b353496")!)
            let svc = SFSafariViewController(URL: NSURL(string: "https://www.linkedin.com/in/nancy-zhao-ying-li-9b353496")!)
            svc.delegate = self
            self.presentViewController(svc, animated: true, completion: nil)
        
            
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
           
         
          // safari.openURL(NSURL(string: "https://github.com/NancyZhaoLi")!)
            
            let svcc = SFSafariViewController(URL: NSURL(string: "https://github.com/NancyZhaoLi")!)
            svcc.delegate = self
            self.presentViewController(svcc, animated: true, completion: nil)
            
            
        
        }
        
       // self.view.window.dismissViewControllerAnimated(true, completion: nil)
      //  viewDidLoad()
        //super.viewDidLoad()
       // safari = UIApplication.sharedApplication()
        
    }
    
    
    
  /*  @IBAction func nancygithub(sender: AnyObject) {
        
        safari.openURL(NSURL(string: "https://github.com/NancyZhaoLi")!)
        
    }*/
    
    
    
    
    
    
    
    
     @IBAction func xinlink(sender: UIButton) {
    
        if( sender.currentImage! == UIImage(named:"linkdin_f.png")){
            print(sender)
            // safari.openURL(NSURL(string: "https://www.linkedin.com/in/xin-lin-7a5872b5")!)
            let svc = SFSafariViewController(URL: NSURL(string:"https://www.linkedin.com/in/xin-lin-7a5872b5")!)
            svc.delegate = self
            self.presentViewController(svc, animated: true, completion: nil)
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
            
            
            
            // print("havn't added")
            //safari.openURL(NSURL(string: "https://github.com/x58lin")!)
            let svcc = SFSafariViewController(URL: NSURL(string:"https://github.com/x58lin")!)
            svcc.delegate = self
            self.presentViewController(svcc, animated: true, completion: nil)
            
            
        }
       
        //aboutusViewController.dismissViewControllerAnimated(true, completion: nil)
        //self.aboutusViewController.dismissViewControllerAnimated(true, completion: nil)
        //self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    
     @IBAction func emilylink(sender: UIButton) {
    
        if( sender.currentImage! == UIImage(named:"linkdin_f.png")){
            print(sender)
           // safari.openURL(NSURL(string: "https://www.linkedin.com/in/yuning-xue-a5920a62")!)
            let svcc = SFSafariViewController(URL: NSURL(string:"https://www.linkedin.com/in/yuning-xue-a5920a62")!)
            svcc.delegate = self
            self.presentViewController(svcc, animated: true, completion: nil)
            
            
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
            
            
            
            // print("havn't added")
          // safari.openURL(NSURL(string: "https://github.com/xyuning")!)
            let svc = SFSafariViewController(URL: NSURL(string:"https://github.com/xyuning")!)
            svc.delegate = self
            self.presentViewController(svc, animated: true, completion: nil)
            
        }
        //self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    
     @IBAction func monicalink(sender: UIButton) {
    
        if( sender.currentImage! == UIImage(named:"twitter_f.png")){
            //print(sender)
            
            let svc = SFSafariViewController(URL: NSURL(string:"https://twitter.com/lalaphoon")!)
            svc.delegate = self
            self.presentViewController(svc, animated: true, completion: nil)
            
            //safari.openURL(NSURL(string: "https://twitter.com/lalaphoon")!)
        }
        else if (sender.currentImage! == UIImage(named:"github_f.png")) {
            
            
            
            // print("havn't added")
            //safari.openURL(NSURL(string: "https://github.com/lalaphoon")!)
            let svcc = SFSafariViewController(URL: NSURL(string:"https://github.com/lalaphoon")!)
            svcc.delegate = self
            self.presentViewController(svcc, animated: true, completion: nil)
            
            
        }
        //self.dismissViewControllerAnimated(true, completion: nil)
    
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
