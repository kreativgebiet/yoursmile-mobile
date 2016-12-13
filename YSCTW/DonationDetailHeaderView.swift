//
//  DonationDetailHeaderView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationDetailHeaderView: UIView {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var donationReceiverView: UIView!
    @IBOutlet weak var selfieImageView: UIImageView!
    
    @IBOutlet weak var donatorProfileImageView: UIImageView!
    @IBOutlet weak var donatorNameLabel: UILabel!
    
    @IBOutlet weak var selfieCommentLabel: UILabel!
    @IBOutlet weak var transparentProjectView: TransparentProjectView!
    
    public var donation: Upload?
    
    @IBOutlet var view: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        UINib(nibName: "DonationDetailHeaderView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.addStyle()
        self.addHeaderData()
    }
    
    func addStyle() {
        //Header Style
        self.donatorProfileImageView.layer.cornerRadius = self.donatorProfileImageView.frame.size.width/2
        self.donatorProfileImageView.clipsToBounds = true
        self.donatorNameLabel.textColor = navigationBarGray

        self.donationReceiverView.backgroundColor = navigationBarGray.withAlphaComponent(0.6)
        self.timeLabel.textColor = timeGray
        
        self.selfieCommentLabel.textColor = spacerGray
    }
    
    func addHeaderData() {
        
        self.donatorProfileImageView.image = self.donation?.profile?.image
        self.donatorNameLabel.text = self.donation?.profile?.name
        self.transparentProjectView.projects = (self.donation?.projects)!

        let imageURL = URL(string: (self.donation?.imageURL)!)!
        self.selfieImageView.af_setImage(withURL: imageURL)
        
        self.selfieCommentLabel.text = self.donation?.description
        
        self.timeLabel.text = self.donation?.date.offset(from: Date())
    }
    
}
