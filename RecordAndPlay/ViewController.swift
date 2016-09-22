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
    var timeTimer: NSTimer?
    var miliSeconds: Int = 0
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    let isRecorderAudioFile = false
    var recordings: [NSURL] = []
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnPlay.enabled = false
        //view.backgroundColor = blackColor()
        listRecordings()
        title = ""
        let nav = self.navigationController?.navigationBar
        //nav!.barTintColor = UIColor.blackColor()
        nav!.barTintColor = UIColor.init(colorLiteralRed: 78.0/255, green: 158.0/255, blue: 255.0/255, alpha: 1.0)
        nav!.tintColor = UIColor.whiteColor()
        nav!
            .titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let viewRecordingList: UIBarButtonItem = UIBarButtonItem(title: "View list",style: .Plain, target: self, action: #selector(self.showRecordedList))
        self.navigationItem.setRightBarButtonItem(viewRecordingList, animated: true)
        
    }
    
    //MARK:- Method store sound in Directory.
    
    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        //let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        let soundURL =  documentDirectory.URLByAppendingPathComponent(NSUUID().UUIDString + ".m4a")
        print(soundURL)
        return soundURL
    }
    
    @IBAction func doRecording(sender: AnyObject) {
        timeTimer?.invalidate()
        if sender.titleLabel!!.text == "Record" {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
                                                    settings: recordSettings)
                audioRecorder.prepareToRecord()
            } catch {
            }
            do {
                self.btnRecord.setTitle("Stop", forState: UIControlState.Normal)
                self.btnPlay.enabled = false
                try audioSession.setActive(true)
                
                //
                miliSeconds = 0
                timerLabel.text = "00:00:00"
                timeTimer = NSTimer.scheduledTimerWithTimeInterval(0.0167, target: self, selector: #selector(self.updateTimerLabel(_:)), userInfo: nil, repeats: true)
                //
                
                audioRecorder.record()
                self.listRecordings()
            } catch {
            }
        }else{
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                self.btnRecord.setTitle("Record", forState: UIControlState.Normal)
                self.btnPlay.enabled = true
                try audioSession.setActive(false)
            } catch {
            }
        }
        
    }
    @IBAction func doPlay(sender: AnyObject) {
        if !audioRecorder.recording {
            self.audioPlayer = try! AVAudioPlayer(contentsOfURL: audioRecorder.url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
            //
            self.listRecordings()
            //
        }
    }
    
    // show list of recorded files
    
    
     func showRecordedList() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("recordingListVCIdentifier") as! RecordingListVC
        vc.getFileName = self.recordings
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //MARK:- AudioRecordDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print(true)
    }
    
    //MARK:- AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print(true)
        //print(self.recordings.count)
        //print(self.recordings[0])
        
        
        
    }
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?){
        print(error.debugDescription)
    }
    internal func audioPlayerBeginInterruption(player: AVAudioPlayer){
        print(player.debugDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func listFile(atPath path: String) -> [Any] {
    //        print("LISTING ALL FILES FOUND")
    //        var count: Int
    //        var directoryContent = try! NSFileManager.defaultManager().contentsOfDirectory(at: path)!
    //        for count in 0..<Int(directoryContent.count) {
    //            print("File \(count + 1): \(directoryContent[count])")
    //        }
    //        return directoryContent
    //    }
    
    func listRecordings() {
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        do {
            let urls = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsDirectory, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
            self.recordings = urls.filter( { (name: NSURL) -> Bool in
                return name.lastPathComponent!.hasSuffix("m4a")
            })
            
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("something went wrong")
        }
    }
    
    func updateTimerLabel(timer: NSTimer) {
        miliSeconds += 1
        let milli = (miliSeconds % 60) + 39
        let sec = (miliSeconds / 60) % 60
        let min = miliSeconds / 3600
        timerLabel.text = NSString(format: "%02d:%02d:%02d", min, sec, milli) as String
        
    }
    
}

