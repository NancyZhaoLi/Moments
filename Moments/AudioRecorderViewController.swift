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
    
    var startButton: UIButton!
    var pauseButton: UIButton!
    var stopButton: UIButton!
    var timeLabel: UILabel!
    var audioTitle: UITextField!
    //var audioDescription: UITextView!

    let pauseImageTitle = "pause_icon.png"
    let pauseGrayImageTitle = "pause_icon.png"
    let recorderImageTitle = "recorder_icon.png"
    let stopImageTitle = "stop_icon.png"
    
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
                        self.dismiss(true)
                    }
                }
            }
        } catch {
            print("Error - [AudioRecorderViewController] - fail to begin recordSession")
            self.dismiss(true)
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
            self.dismiss(true)
        }
    }
    
    func initUI() {
        self.view = UIView(frame: CGRectMake(0,0,windowWidth, windowHeight))
        self.view.backgroundColor = UIColor.customBackgroundColor()
        
        let saveButton = NavigationHelper.rightNavButton("Save", target: self, action: "saveRecording")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        let startButtonSize = windowWidth / 2.0
        let stopButtonSize = windowWidth / 6.0

        startButton = ButtonHelper.imageButton(recorderImageTitle, center: CGPointMake(startButtonSize, startButtonSize + 20.0), imageSize: startButtonSize, target: self, action: "start")
        
        stopButton = ButtonHelper.imageButton(stopImageTitle, center: CGPointMake(stopButtonSize/2.0 + 20.0, startButton.frame.maxY + 10.0), imageSize: stopButtonSize, target:self, action: "stop")
        
        pauseButton = ButtonHelper.imageButton(pauseGrayImageTitle, center: CGPointMake(windowWidth - stopButtonSize/2.0 - 20.0, startButton.frame.maxY + 10.0), imageSize: stopButtonSize, target: self, action: "pause")
        
        disableStopAndPause()
        
        timeLabel = UILabel()
        timeLabel.font = UIFont(name: "Helvetica-Bold", size: 25.0)
        timeLabel.text = computeTimeString(0.0)
        timeLabel.frame.size = UIHelper.textSize(timeLabel.text!, font: timeLabel.font)
        timeLabel.center = CGPointMake(windowWidth/2.0, 0)
        timeLabel.frame.origin.y = stopButton.frame.maxY - timeLabel.frame.size.height
        timeLabel.textColor = UIColor.customGreenColor()

        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 25.0)
        titleLabel.text = "Title"
        titleLabel.frame.size = UIHelper.textSize(titleLabel.text!, font: titleLabel.font)
        titleLabel.frame.origin.y = stopButton.frame.maxY + 20.0
        titleLabel.frame.origin.x = 20.0
        titleLabel.textColor = UIColor.customGreenColor()
        
        /*let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont(name: "Helvetica-Bold", size: 25.0)
        descriptionLabel.text = "Description "
        descriptionLabel.frame.size = UIHelper.textSize(descriptionLabel.text!, font:descriptionLabel.font)
        descriptionLabel.frame.origin.y = titleLabel.frame.maxY + 20.0
        descriptionLabel.frame.origin.x = 20.0
        descriptionLabel.textColor = UIColor.customGreenColor()*/
        
        audioTitle = UITextField(frame: CGRectMake(titleLabel.frame.maxX + 30.0, titleLabel.frame.origin.y, windowWidth - 50.0 - titleLabel.frame.maxX, titleLabel.frame.height))
        audioTitle.placeholder = "Audio"
        audioTitle.backgroundColor = UIColor.whiteColor()
        audioTitle.borderStyle = UITextBorderStyle.RoundedRect
        audioTitle.layer.borderColor = UIColor.customGreenColor().CGColor
        audioTitle.layer.borderWidth = 1.0
        audioTitle.layer.cornerRadius = 5.0
        
        /*audioDescription = UITextView(frame: CGRectMake(20.0, descriptionLabel.frame.maxY + 15.0, windowWidth - 40.0, 80.0))
        audioDescription.backgroundColor = UIColor.whiteColor()
        audioDescription.layer.borderColor = UIColor.grayColor().CGColor
        audioDescription.layer.borderWidth = 1.0
        audioDescription.layer.cornerRadius = 10.0*/
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        self.view.addSubview(startButton)
        self.view.addSubview(pauseButton)
        self.view.addSubview(stopButton)
        self.view.addSubview(timeLabel)
        self.view.addSubview(titleLabel)
        //self.view.addSubview(descriptionLabel)
        self.view.addSubview(audioTitle)
        //self.view.addSubview(audioDescription)
    }
    
    
    func start() {
        if !haveRecorded {
            haveRecorded = true
        }
        //self.startOrPauseButton.setTitle("Pause", forState: UIControlState.Normal)
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        enableStopAndPause()
        startButton.enabled = false
        
        if self.recorder!.record() == true {
            print("sucessfully record")
        } else {
            print("failed to record")
        }
    }
    
    func pause() {
        //self.startOrPauseButton.setTitle("Resume", forState: UIControlState.Normal)
        
        print("pause")
        recorder!.pause()
        pauseButton.setBackgroundImage(UIImage(named: pauseImageTitle)!, forState: .Normal)
        pauseButton.removeTarget(self, action: "pause", forControlEvents: .TouchUpInside)
        pauseButton.addTarget(self, action: "resume", forControlEvents: .TouchUpInside)
        timer!.invalidate()
    }
    
    func resume() {
        print("resume")
        pauseButton.setBackgroundImage(UIImage(named: pauseGrayImageTitle)!, forState: .Normal)
        pauseButton.removeTarget(self, action: "resume", forControlEvents: .TouchUpInside)
        pauseButton.addTarget(self, action: "pause", forControlEvents: .TouchUpInside)
        start()
    }
    
    func stop() {
        haveRecorded = false
        disableStopAndPause()
        startButton.enabled = true
        self.recorder!.stop()
        self.timer!.invalidate()
    }
    
    func enableStopAndPause() {
        stopButton.enabled = true
        pauseButton.enabled = true
    }
    
    func disableStopAndPause() {
        stopButton.enabled = false
        pauseButton.enabled = false
    }
    
    func saveRecording() {
        if recorder.recording {
            stop()
        }
        
        if let delegate = self.delegate {
            print("recording url: \(recorder.url)")
            self.dismiss(true)
            delegate.saveRecording(self, url: self.recorder!.url)
            print("save recording done")
        } else {
            print("no delegate for recording")
            self.dismiss(true)
        }
    }
    
    func updateTime() {
        let currentTime = self.recorder!.currentTime
        self.timeLabel.text = computeTimeString(currentTime)
    }


    private func computeTimeString(second: NSTimeInterval) -> String {
        var secondInt : Int = Int(round(second))
        
        let hour: Int = secondInt / 3600
        secondInt -= hour * 3600
        let minute : Int = secondInt / 60
        secondInt -= minute * 60
        
        let hourString = String(format: "%02d", hour)
        let minuteString = String(format: "%02d", minute)
        let secondString = String(format: "%02d", secondInt)

        return hourString + " : " + minuteString + " : " + secondString
    }
}
