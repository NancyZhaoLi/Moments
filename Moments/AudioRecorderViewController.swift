//
//  AudioRecorderViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-14.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioRecoderViewControllerDelegate {
    func saveRecording(controller: AudioRecorderViewController, url: NSURL)
    func cancelRecording(controller: AudioRecorderViewController)
}

class AudioRecorderViewController: UIViewController {
    static let recorderSetting = [
        AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    var recorder: AVAudioRecorder?
    var recordingSession: AVAudioSession?

    var haveRecorded: Bool = false
    var timer: NSTimer?
    var delegate: AudioRecoderViewControllerDelegate?
    
    @IBOutlet weak var startOrPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try self.recordingSession!.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try self.recordingSession!.setActive(true)
            self.recordingSession!.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        self.initialize()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startOrPause(sender: AnyObject) {
        if self.recorder!.recording {
            pause()
        } else {
            if !haveRecorded {
                haveRecorded = true
                stopButton.enabled = true
            }
            start()
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        stopButton.enabled = false
        self.recorder!.stop()
        haveRecorded = false
        self.startOrPauseButton.setTitle("Start", forState: UIControlState.Normal)
        self.timer!.invalidate()
    }
    
    @IBAction func saveRecording(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.saveRecording(self, url: self.recorder!.url)
        }
    }
    
    @IBAction func cancelRecording(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.cancelRecording(self)
        }
    }
    
    func initialize() {
        let audioFilename: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let audioURL: NSURL = NSURL(fileURLWithPath: audioFilename).URLByAppendingPathComponent("recording.m4a")
        
        do {
            self.recorder = try AVAudioRecorder(URL: audioURL, settings: AudioRecorderViewController.recorderSetting)
            
        } catch {
            let nserror = error as NSError
            NSLog("Recorder failed to be created \(nserror)")
            abort()
        }
        self.stopButton.enabled = false
        if self.recorder!.prepareToRecord() {
            print("prepareToRecord success")
        } else {
            print("prepareToRecord failed")
        }
    }
    
    func updateTime() {
        let currentTime = self.recorder!.currentTime
        self.timeLabel.text = String(currentTime)
    }
    
    func pause() {
        self.startOrPauseButton.setTitle("Resume", forState: UIControlState.Normal)
        self.recorder!.pause()
        self.timer!.invalidate()
    }
    
    func start() {
        self.startOrPauseButton.setTitle("Pause", forState: UIControlState.Normal)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        if self.recorder!.record() == true {
            print("sucessfully record")
        } else {
            print("failed to record")
        }
    }

}
