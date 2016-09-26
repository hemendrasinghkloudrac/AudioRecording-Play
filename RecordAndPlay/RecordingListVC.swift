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
    //var getFileName: [NSURL] = []
    var audioRecording: AVAudioRecorder!
    var audioFilePlayer: AVAudioPlayer!
    var deleteFileAtIndexPath: NSIndexPath? = nil
    //var fileArr = NSArray()
    //var vcObj = ViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recordings"
        self.fileNameTblView.rowHeight = 55
        // Do any additional setup after loading the view.
        print(recordings.count)
        //fileArr = getFileName
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recordings.count
        //return self.getFileName.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> RecordingFileNameCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recordingFileCellIdentifier", forIndexPath: indexPath) as! RecordingFileNameCell
        cell.recordedFileName!.text = recordings[indexPath.row].lastPathComponent
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let fileURL = recordings[indexPath.row]
        //print(fileURL)
        self.audioFilePlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        self.audioFilePlayer.prepareToPlay()
        self.audioFilePlayer.delegate = self
        self.audioFilePlayer.play()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteFileAtIndexPath = indexPath
            let fileURLToDelete = recordings[indexPath.row]
            confirmDelete(fileURLToDelete)
        }
    }
    
    func confirmDelete(fileURL: NSURL) {
        let alert = UIAlertController(title: "Delete audio", message: "Are you sure to permanently delete \(fileURL)?", preferredStyle: .ActionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: removeFile)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:cancle)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    func cancle(alertAction: UIAlertAction!) -> Void {
    
    
    }
    
    func removeFile(alertAction: UIAlertAction ) -> Void {
        if let indexPath = deleteFileAtIndexPath {
         let filePath = recordings[indexPath.row].relativePath
            print(filePath)
            if NSFileManager.defaultManager().fileExistsAtPath(filePath!){
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(filePath!)
                    deleteFileAtIndexPath = nil
                    recordings.removeAtIndex(indexPath.row)
                    print("Old File has been removed")
                    fileNameTblView.reloadData()
                } catch {
                    print("An error during a removing")
                }
            }
        }
    }
    
    
    
}
