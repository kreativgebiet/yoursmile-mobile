//
//  FeedViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import Alamofire

class FeedViewController: UIViewController {
    
    public var dataManager: DataManager?
    public var uploads = [Upload]()
    var feedTableViewController: FeedTableViewController!
    
    @IBOutlet weak var progressView: CancelableProgressView!
    @IBOutlet weak var progressViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressViewHeightConstraint.constant = 0
        self.progressView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(showUploadProgress(_:)), name: NSNotification.Name(rawValue: showUploadNotificationIdentifier), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(uploadProgress(_:)), name: NSNotification.Name(rawValue: uploadProgressNotificationIdentifier), object: nil)
        
        
        self.progressView.cancel = {
            self.progressViewHeightConstraint.constant = 0
            self.progressView.isHidden = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var currentRequest: Request?
    
    func showUploadProgress(_ notification: NSNotification) {
        
        if let request = notification.userInfo?["request"] as? Request {
            currentRequest = request
        }
        
        self.progressView.isHidden = false
        self.progressViewHeightConstraint.constant = 34
        self.progressView.progress = 0
        
    }
    
    func uploadProgress(_ notification: NSNotification) {
        
        if let progress = notification.userInfo?["progress"] as? Progress {
            
            let value = progress.fractionCompleted
            if value < 1 {
                self.progressView.progress = Float(value)
            } else {
                self.progressViewHeightConstraint.constant = 0
                self.progressView.isHidden = true
            }
        }
        
    }
    
    // MARK: - Reload
    
    func reload() {
        self.feedTableViewController.uploads = self.uploads
        self.feedTableViewController.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.feedTableViewController = segue.destination as! FeedTableViewController
        self.feedTableViewController.uploads = self.uploads
        
        self.feedTableViewController.refreshCallback = {
            
            self.dataManager?.uploadsWith(nil, { (uploads) in
                self.uploads = uploads
                self.reload()
            })
            
        }
        
        self.feedTableViewController.projectCallback = { project in
            
            let loadingScreen = LoadingScreen(frame: (self.navigationController?.view.bounds)!)
            self.view.addSubview(loadingScreen)
            
            self.dataManager?.projects({ (projects) in
                loadingScreen.removeFromSuperview()
                
                let filteredProjects = projects.filter({$0.id == project.id})
                
                if filteredProjects.count == 1 {
                    let loadedProject = filteredProjects.last
                    self.navigationController?.performSegue(withIdentifier: "projectSegue", sender: loadedProject)
                    
                }
                
            })
            
        }
        
        feedTableViewController.likeCallback = { project in
            self.dataManager?.likeUploadWith(project.id, { (success, errorMessage) in
                
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
