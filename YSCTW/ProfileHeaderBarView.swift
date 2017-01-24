//
//  ProfileHeaderBarView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 24.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import Foundation
class ProfileHeaderBarView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var preferncesButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    public var backButtonCallback: (() -> Void)?
    public var profile: Profile?
    public var userProfile: Profile?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UINib(nibName: "ProfileHeaderBarView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        
        view.frame = self.bounds
        self.nameLabel.textColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //A Profile of a different user is displayed
        if self.profile == nil {
            self.backButton.isHidden = true
            self.preferncesButton.isHidden = false
        } else if self.profile?.id == self.userProfile?.id {
            self.preferncesButton.isHidden = true
        } else {
            self.preferncesButton.isHidden = true
        }
        
        //If no specific profile is selected user profile is used
        let profileToUse = ((self.profile != nil) ? self.profile : self.userProfile)!
        
        self.nameLabel.text = profileToUse.name
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func menuButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: preferencesNotificationIdentifier), object: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.backButtonCallback!()
    }
}
