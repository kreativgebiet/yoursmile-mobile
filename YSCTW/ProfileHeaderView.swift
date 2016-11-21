//
//  ProfileHeaderView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 10.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    @IBOutlet weak var profileImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var subscribeButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var subscribeButton: RoundedButton!
    @IBOutlet weak var subscribedLabel: UILabel!
    @IBOutlet weak var subscriberLabel: UILabel!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var preferencesButton: UIButton!
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var projectNumberLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    public var profile: Profile?
    public var userProfile: Profile?
    
    public var backButtonCallback: (() -> Void)?
    public var subscribeCallback: (() -> Void)?
    public var cameraCallback: (() -> Void)?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        UINib(nibName: "ProfileHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.view.backgroundColor = navigationBarGray
        
        self.subscriptionView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        self.subscribedLabel.textColor = customGray
        self.subscriberLabel.textColor = customGray
        
        self.profileNameLabel.textColor = .white
        self.projectNumberLabel.textColor = customGray
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleImageTapped))
        self.profileImageView.addGestureRecognizer(tapGesture)
        self.profileImageView.isUserInteractionEnabled = true
        
        self.backgroundImageView.alpha = 0.2
        
        self.topImageView.clipsToBounds = true
        self.topImageView.alpha = 0
        
        self.subscribeButton.backgroundColor = .clear
        self.subscribeButton.layer.borderColor = spacerGray.cgColor
        self.subscribeButton.layer.borderWidth = 2
        self.subscribeButton.setTitle("SUBSCRIBE".localized, for: .normal)
        self.subscribeButton.setTitle("SUBSCRIBE".localized, for: .selected)
        
        self.backButton.imageView?.contentMode = .center
        
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileLabel.text = "PROFILE".localized
        
        self.profileImageView.layer.cornerRadius = self.profileImageViewWidthConstraint.constant/2
        self.topImageView.layer.cornerRadius = self.topImageView.frame.size.height/2
        
        //A Profile of a different user is displayed
        if self.profile == nil {
            self.subscribeButtonHeight.constant = 0
            self.subscribeButton.alpha = 0
            self.backButton.isHidden = true
            self.preferencesButton.isHidden = false
        } else {
            self.preferencesButton.isHidden = true
        }
        
        //If no specific profile is selected user profile is used
        let profileToUse = ((self.profile != nil) ? self.profile : self.userProfile)!
        
        self.profileNameLabel.text = profileToUse.userName
        
        let numberOfProjectsSupported = profileToUse.numberOfDonations != nil ? profileToUse.numberOfDonations : 0
        
        self.projectNumberLabel.text = String(Int(numberOfProjectsSupported!)) + " " + "PROJECTS_SUPPORTED".localized
        
        self.subscriberLabel.text = "0" + " " + "SUBSCRIBER".localized
        self.subscribedLabel.text = "0" + " " + "SUBSCRIBED".localized
        
        if profileToUse.profileImage != nil {
            self.profileImageView.image = profileToUse.profileImage
            self.backgroundImageView.image = profileToUse.profileImage
            self.profileImageView.clipsToBounds = true
            self.topImageView.image = profileToUse.profileImage

        } else {
            
            if self.profile == nil {
                self.profileImageView.clipsToBounds = false
                self.profileImageView.image = #imageLiteral(resourceName: "default-profile-icon")
            } else {
                self.profileImageView.clipsToBounds = false
                self.profileImageView.image = #imageLiteral(resourceName: "user-icon")
            }
            
        }
        
    }
    
    @IBAction func handlePreferencesButtonTapped(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: preferencesNotificationIdentifier), object: nil)
    }

    @IBAction func handleSubscribeButtonTapped(_ sender: AnyObject) {
        self.subscribeCallback!()
    }
    
    @IBAction func handleBackButtonTapped(_ sender: AnyObject) {
        self.backButtonCallback!()
    }

    func handleImageTapped() {
        self.cameraCallback!()
    }
}
