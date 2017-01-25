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
    var profileHeaderBarView: ProfileHeaderBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.profileHeaderView.profile = self.currentProfile
        self.profileHeaderView.userProfile = self.userProfile
        self.profileHeaderView.layoutIfNeeded()
        
        self.profileHeaderBarView = ProfileHeaderBarView(frame: CGRect(x: 0, y: -60, width: self.view.frame.width, height: 60))
        self.profileHeaderBarView.profile = self.currentProfile
        self.profileHeaderBarView.userProfile = self.userProfile
        self.profileHeaderBarView.backgroundColor = customGray2
        
        self.profileHeaderBarView.backButtonCallback = {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
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
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func applyTableViewStyle() {
        self.tableView.rowHeight = 467
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = customLightGray
        self.tableView.separatorColor = customGray
    }
    
    func reloadUserData() {
        self.dataManager?.userDataFor(id: self.idString(), { (profile) in            
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
        self.tableView.contentInset = UIEdgeInsets.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.profileHeaderView.setNeedsLayout()
        self.profileHeaderView.layoutIfNeeded()
        
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
        self.tableView.contentInset = UIEdgeInsets.zero
        
        self.profileViewHeightConstraint.constant = self.initialProfileViewHeightConstraint
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.profileHeaderBarView.frame = CGRect(x: 0, y: -60, width: self.view.frame.width, height: 60)
        
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.profileViewHeightConstraint.constant > self.initialProfileViewHeightConstraint {
            self.profileViewHeightConstraint.constant = self.initialProfileViewHeightConstraint
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
            })
        }
    }
    
    var animating = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentHeight = scrollView.contentSize.height
        let heightForContent = self.view.frame.height - self.profileViewHeightConstraint.constant
        let profileHeaderHeight = self.profileHeaderBarView.frame.height

        if contentHeight == 0 || animating{
            return
        } else if contentHeight < heightForContent {
            if self.profileHeaderBarView.superview == nil {
                self.animateProfileHeaderBarView(show: true, completion: { (completed) in
                    self.profileViewHeightConstraint.constant = profileHeaderHeight
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
                return
            }
        }
        
        if scrollView.contentOffset.y > 0 && self.profileViewHeightConstraint.constant > 0 && self.profileViewHeightConstraint.constant != 60 {
            let newConstant: CGFloat = self.profileViewHeightConstraint.constant - scrollView.contentOffset.y
            
            self.profileViewHeightConstraint.constant = newConstant
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
            //self.tableView.setContentOffset(CGPoint.zero, animated: false)
        } else if scrollView.contentOffset.y < 0  {
            let newConstant: CGFloat = min(self.profileViewHeightConstraint.constant - scrollView.contentOffset.y, self.initialProfileViewHeightConstraint + 50)
            
            self.profileViewHeightConstraint.constant = newConstant
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
            self.profileViewHeightConstraint.constant = self.initialProfileViewHeightConstraint
            
            UIView.animate(withDuration: 0.2, animations: { 
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
            })
        }
        
        if self.profileViewHeightConstraint.constant < profileHeaderHeight + 10 && self.profileHeaderBarView.superview == nil {
            self.animateProfileHeaderBarView(show: true)
        } else if self.profileViewHeightConstraint.constant > profileHeaderHeight + 10  && self.profileHeaderBarView.superview != nil {
            self.animateProfileHeaderBarView(show: false)
        }
    }
    
    func animateProfileHeaderBarView(show: Bool, completion: ((Bool) -> Swift.Void)? = nil) {
        animating = true
        
        if show {
            let profileHeaderHeight = self.profileHeaderBarView.frame.height
            
            self.view.addSubview(self.profileHeaderBarView)
            
            self.profileViewHeightConstraint.constant = profileHeaderHeight
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                var frame = self.profileHeaderBarView.frame
                frame.origin.y = 0
                
                self.profileHeaderBarView.frame = frame
            }, completion: { (completed) in
                self.animating = false
                if completion != nil {
                    completion!(completed)
                }
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                var frame = self.profileHeaderBarView.frame
                frame.origin.y = -frame.height
                
                self.profileHeaderBarView.frame = frame
            }, completion: { (completed) in
                self.profileHeaderBarView.removeFromSuperview()
                self.animating = false
                if completion != nil {
                    completion!(completed)
                }
            })
        }
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

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
