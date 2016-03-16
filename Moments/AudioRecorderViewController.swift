//
//  AudioRecorderViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-14.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioRecorderViewControllerDelegate {
    func saveRecording(controller: AudioRecorderViewController, url: NSURL)
}

class AudioRecorderViewController: UIViewController {
    static let recorderSetting = [
        AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
        AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
        AVEncoderBitRateKey : 320000,
        AVNumberOfChannelsKey: 2,
        AVSampleRateKey : 44100.0
    ]
    
    var recorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!

    var haveRecorded: Bool! = false
    var timer: NSTimer?
    var delegate: AudioRecorderViewControllerDelegate?
    
    var startOrPauseButton: UIButton!
    var stopButton: UIButton!
    var timeLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(sourceView: nil, delegate: nil)
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(sourceView: UIView?, delegate: AudioRecorderViewControllerDelegate?) {
        self.haveRecorded = false
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        
        initRecordingSession()
        initUI()
        
        self.modalPresentationStyle = .Popover
        if let popover = self.popoverPresentationController {
            popover.delegate = self.delegate as? UIPopoverPresentationControllerDelegate
            if let sourceView = sourceView {
                popover.sourceView = sourceView
                popover.sourceRect = CGRectMake(CGRectGetMidX(sourceView.frame),CGRectGetMidY(sourceView.frame),0,0)
            }
            self.preferredContentSize = self.view.frame.size
        }
    }
    
    func initRecordingSession() {
        self.recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try self.recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try self.recordingSession.setActive(true)
            self.recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        self.initRecorder()
                    } else {
                        print("Error - [AudioRecorderViewController] - fail to begin recordSession")
                        self.cancelRecording()
                    }
                }
            }
        } catch {
            print("Error - [AudioRecorderViewController] - fail to begin recordSession")
            self.cancelRecording()
        }
    }
    
    func initRecorder() {
        let audioFilename: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let audioURL: NSURL = NSURL(fileURLWithPath: audioFilename).URLByAppendingPathComponent("recording.m4a")
        
        do {
            self.recorder = try AVAudioRecorder(URL: audioURL, settings: AudioRecorderViewController.recorderSetting)
        } catch {
            let nserror = error as NSError
            NSLog("Recorder failed to be created \(nserror)")
            abort()
        }

        if self.recorder.prepareToRecord() {
            print("Error - [AudioRecordingViewController] - failed to prepare recorder")
            self.cancelRecording()
        }
    }
    
    func initUI() {
        self.view = UIView(frame: CGRectMake(0,0,220, 150))
        self.view.backgroundColor = UIColor.whiteColor()
        
        let cancelButton = UIButton(frame: CGRectMake(0,3, 60, 37))
        cancelButton.addTarget(self, action: "cancelRecording", forControlEvents: .TouchUpInside)
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        
        let saveButton = UIButton(frame: CGRectMake(self.view.frame.width - 50,3,50,37))
        saveButton.addTarget(self, action: "saveRecording", forControlEvents: .TouchUpInside)
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
    
        startOrPauseButton = UIButton(frame: CGRectMake(45,20,60,37))
        startOrPauseButton.setTitle("Start", forState: UIControlState.Normal)
        startOrPauseButton.setTitleColor(UIColor.customGreenColor(), forState: .Normal)
        startOrPauseButton.addTarget(self, action: "startOrPause", forControlEvents: .TouchUpInside)
        
        stopButton = UIButton(frame: CGRectMake(self.view.frame.width - 96, 20,50,37))
        stopButton.setTitle("Stop", forState: .Normal)
        stopButton.addTarget(self, action: "stop", forControlEvents: .TouchUpInside)
        stopButton.enabled = false
        stopButton.setTitleColor(UIColor.grayColor(), forState: .Normal)

        
        timeLabel = UILabel(frame: CGRectMake(0,0,50,37))
        timeLabel.center = CGPoint(x: self.view.frame.width/2.0, y: 100.0)
        timeLabel.text = "0.0"
        timeLabel.textColor = UIColor.customGreenColor()

        self.view.addSubview(cancelButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(startOrPauseButton)
        self.view.addSubview(stopButton)
        self.view.addSubview(timeLabel)

    }
    
    func startOrPause() {
        if self.recorder!.recording {
            pause()
        } else {
            start()
            if !haveRecorded {
                haveRecorded = true
            }
        }
    }
    
    func stop() {
        haveRecorded = false
        stopButton.enabled = false
        stopButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        startOrPauseButton.setTitle("Start", forState: .Normal)
        self.recorder!.stop()
        self.timer!.invalidate()
    }
    
    func saveRecording() {
        if let delegate = self.delegate {
            delegate.saveRecording(self, url: self.recorder!.url)
        }
    }
    
    func cancelRecording() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.removeFromParentViewController()
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
