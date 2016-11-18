//
//  FeedViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    public var dataManager: DataManager?
    @IBOutlet weak var progressView: CancelableProgressView!
    @IBOutlet weak var progressViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressViewHeightConstraint.constant = 0
        self.progressView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(showUploadProgress), name: NSNotification.Name(rawValue: showUploadNotificationIdentifier), object: nil)
        
        self.progressView.cancel = {
            self.progressViewHeightConstraint.constant = 0
            self.progressView.isHidden = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var timer: Timer!
    
    func showUploadProgress() {
        self.progressView.isHidden = false
        self.progressViewHeightConstraint.constant = 34
        self.progressView.progress = 0
        
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(updateTimer),
                                          userInfo: nil,
                                          repeats: true)
        
    }
    
    func updateTimer() {
        
        let progress = self.progressView.progressView.progress + 0.1
        
        if progress < 1 {
            self.progressView.progress = progress
        } else {
            self.timer.invalidate()
            self.progressViewHeightConstraint.constant = 0
            self.progressView.isHidden = true
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! FeedTableViewController
        destinationVC.donations = self.dataManager?.donations()
    }

}
