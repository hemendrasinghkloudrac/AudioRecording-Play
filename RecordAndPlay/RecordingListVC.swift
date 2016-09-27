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
    var recordings: [NSURL] = []
    var audioRecording: AVAudioRecorder!
    var audioFilePlayer: AVAudioPlayer!
    var deleteFileAtIndexPath: NSIndexPath? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recordings"
        self.fileNameTblView.rowHeight = 55
        listRecordings()
        print(recordings.count)
        fileNameTblView.reloadData()
        
    }
    
    func listRecordings() {
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        do {
            let urls = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsDirectory, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
            recordings = urls.filter( { (name: NSURL) -> Bool in
                return name.lastPathComponent!.hasSuffix("m4a")
            })
            
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("something went wrong")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recordings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> RecordingFileNameCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recordingFileCellIdentifier", forIndexPath: indexPath) as! RecordingFileNameCell
        cell.recordedFileName!.text = recordings[indexPath.row].lastPathComponent
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let fileURL = recordings[indexPath.row]
        self.audioFilePlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        self.audioFilePlayer.prepareToPlay()
        self.audioFilePlayer.volume = 50.0
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
        let alert = UIAlertController(title: "Delete file", message: "Are you sure to permanently delete \(fileURL)?", preferredStyle: .ActionSheet)
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
                    print("An error during a file removing")
                }
            }
        }
    }
}
