//
//  RecordingListVC.swift
//  RecordAndPlay
//
//  Created by HemendraSingh on 21/09/16.
//  Copyright © 2016 Nimble Chapps. All rights reserved.
//

import UIKit

class RecordingListVC: UIViewController, UITableViewDelegate {
    

    @IBOutlet weak var fileNameTblView: UITableView!
    var getFileName: [NSURL] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fileNameTblView.rowHeight = 55
        // Do any additional setup after loading the view.
        print(self.getFileName.count)
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
            cell.recordedFileName!.text = String(getFileName[indexPath.row])
         return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
