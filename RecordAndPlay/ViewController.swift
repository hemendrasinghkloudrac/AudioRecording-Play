//
//  ViewController.swift
//  RecordAndPlay
//
//  Created by Nimble Chapps on 26/04/16.
//  Copyright © 2016 Nimble Chapps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate ,AVAudioPlayerDelegate {
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var recordBtnLabel: UILabel!
    @IBOutlet weak var playBtnLabel: UILabel!
    @IBOutlet weak var pauseBtnLabel: UILabel!
    var timeTimer: NSTimer?
    var miliSeconds: Int = 0
    var audioRecorder:AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    let isRecorderAudioFile = false
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPlay.enabled = false
        pauseBtn.enabled = false
        recordBtnLabel.text = "Record"
        playBtnLabel.hidden = true
        pauseBtnLabel.hidden = true
        let nav = self.navigationController?.navigationBar
        nav!.barTintColor = UIColor.init(colorLiteralRed: 78.0/255, green: 158.0/255, blue: 255.0/255, alpha: 1.0)
        nav!.tintColor = UIColor.whiteColor()
        nav!
            .titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let viewRecordingList: UIBarButtonItem = UIBarButtonItem(title: "View list",style: .Plain, target: self, action: #selector(self.showRecordedList))
        self.navigationItem.setRightBarButtonItem(viewRecordingList, animated: true)
        let saveRecordedFile: UIBarButtonItem = UIBarButtonItem(title: "Save" , style: .Plain, target: self , action: #selector(self.saveAlert))
        self.navigationItem.setLeftBarButtonItem(saveRecordedFile, animated: true)
    }
    
    //MARK:- Method store audio recording file in Directory.
    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4b")
        print(soundURL)
        return soundURL
    }
    
    @IBAction func doRecording(sender: AnyObject) {
        timeTimer?.invalidate()
        if sender.titleLabel!!.text == "rec" {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,settings: recordSettings)
                audioRecorder.prepareToRecord()
            } catch {
            }
            do {
                self.btnRecord.setTitle(" ", forState: UIControlState.Normal)
                self.btnRecord.setImage(UIImage(named: "stopImg.png"), forState: .Normal)
                self.pauseBtn.setImage(UIImage(named: "pauseButton.png"), forState: .Normal)
                self.recordBtnLabel.text = "Stop"
                self.btnPlay.enabled = false
                self.playBtnLabel.hidden = true
                self.pauseBtn.enabled = true
                self.pauseBtnLabel.hidden = false
                self.pauseBtnLabel.text = "Pause"
                try audioSession.setActive(true)
                miliSeconds = 0
                timerLabel.text = "00:00:00"
                timeTimer = NSTimer.scheduledTimerWithTimeInterval(0.0167, target: self, selector: #selector(self.updateTimerLabel(_:)), userInfo: nil, repeats: true)
                audioRecorder.record()
            } catch {
            }
        }else{
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                self.btnRecord.setTitle("rec", forState: UIControlState.Normal)
                self.pauseBtn.setImage(UIImage(named: "pauseButton.png"), forState: .Normal)
                self.btnRecord.setImage(UIImage(named: "recordImg.png"), forState: .Normal)
                self.recordBtnLabel.text = "Record"
                self.btnPlay.enabled = true
                self.playBtnLabel.hidden = false
                self.playBtnLabel.text = "Play"
                self.pauseBtn.enabled = false
                self.pauseBtnLabel.hidden = true
                try audioSession.setActive(false)
            } catch {
            }
        }
    }
    
    @IBAction func doPlay(sender: AnyObject) {
        if !audioRecorder.recording {
            self.audioPlayer = try! AVAudioPlayer(contentsOfURL: audioRecorder.url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.volume = 50.0
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        }
    }
    
    // show list of audio recording files
    func showRecordedList() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("recordingListVCIdentifier") as! RecordingListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- AudioRecordDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print(true)
    }
    
    //MARK:- AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print(true)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(player: AVAudioPlayer){
        print(player.debugDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateTimerLabel(timer: NSTimer) {
        miliSeconds += 1
        let milli = (miliSeconds % 60) + 39
        let sec = (miliSeconds / 60) % 60
        let min = miliSeconds / 3600
        timerLabel.text = NSString(format: "%02d:%02d:%02d", min, sec, milli) as String
    }
    
    @IBAction func PauseRecording(sender: AnyObject) {
        timeTimer?.invalidate()
        if audioRecorder.recording {
            self.audioRecorder.pause()
            self.pauseBtn.setImage(UIImage(named: "resumeImg.png"), forState: .Normal)
            self.pauseBtnLabel.text = "Resume"
        } else {
            self.audioRecorder.record()
            self.pauseBtnLabel.text = "Pause"
            self.pauseBtn.setImage(UIImage(named: "pauseButton.png"), forState: .Normal)
            timeTimer = NSTimer.scheduledTimerWithTimeInterval(0.0167, target: self, selector: #selector(self.updateTimerLabel(_:)), userInfo: nil, repeats: true)
        }
    }
    
    func saveAction() {
        do {
            let documentDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
            let originPath = documentDirectory.URLByAppendingPathComponent("sound.m4b")
            let destinationPath =  documentDirectory.URLByAppendingPathComponent(NSUUID().UUIDString + ".m4a")
            try NSFileManager.defaultManager().moveItemAtURL(originPath!, toURL: destinationPath!)
            print(destinationPath)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func saveAlert() {
        let refreshAlert = UIAlertController(title: "Save file", message: "Do you want to save this Audio file?", preferredStyle: UIAlertControllerStyle.Alert)
        refreshAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action: UIAlertAction!) in
            self.saveAction()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
}

