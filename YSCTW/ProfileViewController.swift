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

    
    public var profileImage: UIImage {
        
        get {
            return self.userProfile.profileImage!
        }
        
        set {
            self.userProfile.profileImage = newValue
            self.profileView.userProfile = self.userProfile
        }
        
    }
    
    @IBOutlet weak var profileView: ProfileHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileViewHeightConstraint: NSLayoutConstraint!
    var initialProfileViewHeightConstraint: CGFloat!
    var donations: [Donation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.donations = self.dataManager?.donations()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView = UIView(frame: CGRect.zero)
        self.tableView.contentInset = UIEdgeInsets.zero
        
        self.profileView.profile = self.currentProfile
        self.profileView.userProfile = self.userProfile
        
        if self.currentProfile == nil {
            self.profileViewHeightConstraint.constant = 285
        }
        
        self.initialProfileViewHeightConstraint = self.profileViewHeightConstraint.constant
        
        self.profileView.subscribeCallback = {
            
        }
        
        self.profileView.backButtonCallback = {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        self.profileView.cameraCallback = {
            self.navigationController?.performSegue(withIdentifier: "cameraSegue", sender: self)
        }
        
        self.applyTableViewStyle()
    }
    
    func applyTableViewStyle() {
        self.tableView.rowHeight = 467
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = customLightGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.profileView.setNeedsLayout()
        self.profileView.layoutIfNeeded()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //Animation is happening here
        if scrollView.contentOffset.y > 0 {
            
            let newConstant: CGFloat = 64
            
            if newConstant != self.profileViewHeightConstraint.constant {
                self.profileViewHeightConstraint.constant = newConstant
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                    
                    self.profileView.topImageView.alpha = 1
                    
                    let profileToUse = ((self.currentProfile != nil) ? self.currentProfile : self.userProfile)!
                    self.profileView.profileLabel.text = profileToUse.userName
                    
                } )

            }
            
        } else {
            
            let newConstant: CGFloat = self.initialProfileViewHeightConstraint
            
            if newConstant != self.profileViewHeightConstraint.constant {
                self.profileViewHeightConstraint.constant = newConstant
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                    
                    self.profileView.topImageView.alpha = 0
                    self.profileView.profileLabel.text = "PROFILE".localized
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
        
        let donation = (self.donations?[indexPath.row])! as Donation
        
        cell.donation = donation
        
        cell.detailCallback = { (donation: Donation) in
            self.navigationController?.performSegue(withIdentifier: "donationDetailSegue", sender: donation)
        }
        
        cell.profileCallback = { (donation: Donation) in
            self.navigationController?.performSegue(withIdentifier: "profileSegue", sender: donation)
        }
        
        return cell
    }

}
