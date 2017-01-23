//
//  ProfileViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var dataManager: DataManager?
    public var currentProfile: Profile?
    public var userProfile = DataManager().userProfile()
    
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileViewHeightConstraint: NSLayoutConstraint!
    var initialProfileViewHeightConstraint: CGFloat!
    var donations: [Upload]?
    var profileToUse: Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.profileHeaderView.profile = self.currentProfile
        self.profileHeaderView.userProfile = self.userProfile
        self.profileHeaderView.layoutIfNeeded()
        
        self.profileToUse = ((self.currentProfile != nil) ? self.currentProfile : self.userProfile)!
        
        if self.currentProfile == nil {
            self.profileViewHeightConstraint.constant = 285
        }
        
        self.initialProfileViewHeightConstraint = self.profileViewHeightConstraint.constant
        
        self.profileHeaderView.subscribeCallback = {
            let loadingScreen = LoadingScreen(frame: self.view.bounds)
            self.view.addSubview(loadingScreen)
            
            let id = (self.currentProfile?.id)! as Int!
            let idString = "\(id!)"
            self.dataManager?.followUserWith(id: idString, { (success, errorString) in
                loadingScreen.removeFromSuperview()
                
                if success {
                    self.profileHeaderView.hideSubscribeButton()
                    self.reloadUserData()
                }
            })
        }
        
        self.profileHeaderView.backButtonCallback = {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        self.profileHeaderView.cameraCallback = {
            self.navigationController?.performSegue(withIdentifier: "cameraSegue", sender: self)
        }
        
        self.applyTableViewStyle()
        self.reloadData()
    }
    
    func applyTableViewStyle() {
        self.tableView.rowHeight = 467
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = customLightGray
    }
    
    func reloadUserData() {
        self.dataManager?.userDataFor(id: self.idString(), { (profile) in
            print(profile)
            
            if self.currentProfile == nil {
                self.profileHeaderView.userProfile = profile
            } else {
                self.profileHeaderView.profile = profile
            }
            
            self.profileHeaderView.setNeedsLayout()
            self.profileHeaderView.layoutIfNeeded()
            
        })
    }
    
    func reloadData() {
        let loadingScreen = LoadingScreen(frame: self.view.bounds)
        self.view.addSubview(loadingScreen)
        
        debugPrint("currentprofile")
        debugPrint(self.currentProfile?.id)
        
        debugPrint("userprofile")
        debugPrint(self.userProfile.id)
        
        self.dataManager?.uploadsWith(self.idString(), { (uploads) in
            self.donations = uploads
            //Could be implemented instead of current implementation
            //            let supportedProjects = self.donations?.map({$0.projects})
            self.profileHeaderView.numberOfSupportedProjects = (self.donations?.count)!
            
            self.tableView.reloadData()
        })
        
        self.reloadUserData()
        
        self.dataManager?.followerForUserWith(id: self.idString(), { (relationProfiles) in
            print(relationProfiles)
            loadingScreen.removeFromSuperview()
            let followerIds = relationProfiles.map({$0.userId})
            
            if followerIds.contains(Int(self.userProfile.id)) {
                self.profileHeaderView.hideSubscribeButton()
            }
            
        })
    }
    
    func idString() -> String {
        let id = self.profileToUse.id as Int!
        return "\(id!)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.profileHeaderView.setNeedsLayout()
        self.profileHeaderView.layoutIfNeeded()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.reloadData()
    }
    
    // MARK: - Upload user profile image
    
    func uploadUser(image: UIImage) {
        let loadingScreen = LoadingScreen(frame: self.view.bounds)
        self.view.addSubview(loadingScreen)
        
        self.dataManager?.uploadUser(image: image, username: self.userProfile.name, { (success, errorString) in
            loadingScreen.removeFromSuperview()
        })
    }
    
    // MARK: - Header animation
    
    var animating = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height == 0 || animating {
            return
        }
        
        //Animation is happening here
        if scrollView.contentOffset.y > 0 {
            
            let newConstant: CGFloat = 64
            
            if newConstant != self.profileViewHeightConstraint.constant {
                self.profileViewHeightConstraint.constant = newConstant
                
                scrollView.isScrollEnabled = false
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                    self.animating = true
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                    
                    self.profileHeaderView.topImageView.alpha = 1
                    
                    let profileToUse = ((self.currentProfile != nil) ? self.currentProfile : self.userProfile)!
                    self.profileHeaderView.profileLabel.text = profileToUse.name
                    
                }, completion: { (completed) in
                    self.animating = false
                    scrollView.setContentOffset(CGPoint(x: 0, y: 1), animated: true)
                    scrollView.isScrollEnabled = true
                })

            }
            
        } else {
            
            let newConstant: CGFloat = self.initialProfileViewHeightConstraint
            
            if newConstant != self.profileViewHeightConstraint.constant {
                self.profileViewHeightConstraint.constant = newConstant
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                    self.animating = true
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                    
                    self.profileHeaderView.topImageView.alpha = 0
                    self.profileHeaderView.profileLabel.text = "PROFILE".localized
                }, completion: { (completed) in
                    self.animating = false
                })
            }
            

        }
        
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        
        if let projects = self.donations?.count {
            numberOfRows = projects
        }
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        
        //Remove separator Insets
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        let donation = (self.donations?[indexPath.row])! as Upload
        
        cell.donation = donation
        
        cell.detailCallback = { (donation: Upload) in
            self.navigationController?.performSegue(withIdentifier: "donationDetailSegue", sender: donation)
        }
        
        cell.profileCallback = { (donation: Upload) in
            self.navigationController?.performSegue(withIdentifier: "profileSegue", sender: donation)
        }
        
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
