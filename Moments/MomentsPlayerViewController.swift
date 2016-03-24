  //
//  MomentsPlayerViewController.swift
//  Moments
//
//  Created by Nancy Li on 2016-02-24.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

  class MomentsPlayerViewController: UIViewController, UIWebViewDelegate {
    
    let fileURL = NSURL(fileURLWithPath: "/Users/nancyli/Programming/Moments/Moments/moments.mp4")
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func saveVideo(sender: UIButton) {
        //call export func in videogen
     
        let alert = UIAlertController(title: "Save Video", message: "Your video has been saved!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
       /* PHPhotoLibrary.sharedPhotoLibrary().performChanges(
        {let req = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(self.fileURL)},
        completionHandler: {success, error in if !success{NSLog("Failed to save.")};})*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        
        webView.loadHTMLString("<iframe width = \" \(self.webView.frame.width*3) \" height = \" \(self.webView.frame.height*3)\" src = \"\(fileURL)\" </iframe>", baseURL: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSnapShot(filePath : String)->UIImage? {
        let fileURL = NSURL(fileURLWithPath: filePath)
        let asset = AVAsset(URL: fileURL)
        let assetImageGen = AVAssetImageGenerator(asset: asset)
        var time = asset.duration
        time.value = min(time.value, 1)
        
        do {
            let image = try assetImageGen.copyCGImageAtTime(time, actualTime: nil)
            return UIImage(CGImage: image)
        } catch{
            return nil
        }
    }
}