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
        self.init(delegate: nil)
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init(delegate: AudioRecorderViewControllerDelegate?) {
        self.haveRecorded = false
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        
        initUI()
        initRecordingSession()
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
        self.view = UIView(frame: CGRectMake(0,0,windowWidth, windowHeight))
        self.view.backgroundColor = UIColor.customBackgroundColor()
        
        let saveButton = NavigationHelper.rightNavButton("Save", target: self, action: "saveRecording")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        let startButtonSize = windowWidth / 2.0
        let stopButtonSize = windowWidth / 6.0
        startOrPauseButton = ButtonHelper.imageButton("text.png", center: CGPointMake(startButtonSize, startButtonSize + 20.0), imageSize: startButtonSize, target: self, action: "startOrPause")
        
        stopButton = ButtonHelper.imageButton("text.png", center: CGPointMake(windowWidth - stopButtonSize/2.0 - 20.0, startOrPauseButton.frame.maxY), imageSize: stopButtonSize, target: self, action: "stop")
        
        let moreOptionBarHeight : CGFloat = 20.0
        let moreOptionBar = UIHelper.line(0, height: moreOptionBarHeight, y: stopButton.frame.maxY + 10.0, colour: UIColor.customBlueColor())
        let plusButton = ButtonHelper.imageButton("add_icon.png", center: CGPointMake(windowWidth/2.0, (moreOptionBarHeight - 4.0)/2.0), imageSize: moreOptionBarHeight - 4.0, target: self, action: "showMoreOption")
        moreOptionBar.addSubview(plusButton)
        
        timeLabel = UILabel()
        timeLabel.font = UIFont(name: "Helvetica-Bold", size: 25.0)
        timeLabel.text = computeTimeString(0.0)
        timeLabel.frame.size = UIHelper.textSize(timeLabel.text!, font: timeLabel.font)
        timeLabel.center = CGPointMake(windowWidth/2.0, 0)
        timeLabel.frame.origin.y = stopButton.frame.maxY - timeLabel.frame.size.height
        timeLabel.textColor = UIColor.customGreenColor()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        self.view.addSubview(startOrPauseButton)
        self.view.addSubview(stopButton)
        self.view.addSubview(timeLabel)
        self.view.addSubview(moreOptionBar)
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
    
    func pause() {
        self.startOrPauseButton.setTitle("Resume", forState: UIControlState.Normal)
        self.recorder!.pause()
        self.timer!.invalidate()
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
        } else {
            self.dismiss(true)
        }
    }
    
    func cancelRecording() {
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.removeFromParentViewController()
        }
    }
    
    func updateTime() {
        let currentTime = self.recorder!.currentTime
        self.timeLabel.text = computeTimeString(currentTime)
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

    private func computeTimeString(var second: NSTimeInterval) -> String {
        let hour: Int = Int(second / 3600.0)
        second -= Double(hour * 3600)
        let minute : Int = Int(second / 60.0)
        second -= Double(minute * 60)
        
        let hourString = String(format: "%02d", hour)
        let minuteString = String(format: "%02d", minute)
        let secondString = String(format: "%02d", second)

        return hourString + " : " + minuteString + " : " + secondString
    }
}
