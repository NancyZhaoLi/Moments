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
    
    var path: String!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func saveVideo(sender: UIButton) {
        let alert = UIAlertController(title: "Save Video", message: "Your video has been saved!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges(
        {let req = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(NSURL(fileURLWithPath: self.path))},
        completionHandler: {success, error in if !success{NSLog("Failed to save.")};})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.webView.backgroundColor = UIColor.clearColor()
        self.webView.opaque = false
        self.view.backgroundColor = UIColor.customBackgroundColor()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let fileURL = NSURL(fileURLWithPath: path)
        webView.loadHTMLString("<iframe width = \" \(self.webView.frame.width*3) \" height = \" \(self.webView.frame.height*3)\" src = \"\(fileURL)\" </iframe>", baseURL: nil)
        
        let audioAsset = AVURLAsset(URL: fileURL)
        let audioDuration = audioAsset.duration;
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        if (audioDurationSeconds < 1.5){
            let alert = UIAlertController(title: "Oh no!", message: "You don't have any moments created within that time range containing images, use a different time range or add more moments so we can generate a better video for you.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        do {            let fileURL = NSURL(fileURLWithPath: path)
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {print("not clean1")}
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