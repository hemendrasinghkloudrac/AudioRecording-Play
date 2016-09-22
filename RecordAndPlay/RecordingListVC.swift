//
//  RecordingListVC.swift
//  RecordAndPlay
//
//  Created by HemendraSingh on 21/09/16.
//  Copyright © 2016 Nimble Chapps. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingListVC: UIViewController,UITableViewDelegate,AVAudioPlayerDelegate {
    
    
    @IBOutlet weak var fileNameTblView: UITableView!
    var getFileName: [NSURL] = []
    var audioRecording: AVAudioRecorder!
    var audioFilePlayer: AVAudioPlayer!
    var fileArr = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fileNameTblView.rowHeight = 55
        // Do any additional setup after loading the view.
        //print(self.getFileName.count)
        fileArr = getFileName
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return self.recordings.count
        return self.getFileName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> RecordingFileNameCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recordingFileCellIdentifier", forIndexPath: indexPath) as! RecordingFileNameCell
        cell.recordedFileName!.text = String(getFileName[indexPath.row].lastPathComponent)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let fileURL = getFileName[indexPath.row]
            //print(fileURL)
            self.audioFilePlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
            self.audioFilePlayer.prepareToPlay()
            self.audioFilePlayer.delegate = self
            self.audioFilePlayer.play()
       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
