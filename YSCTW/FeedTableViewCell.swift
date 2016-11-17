//
//  FeedTableViewCell.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets for data
    @IBOutlet weak var donorLogoImageView: UIImageView!
    @IBOutlet weak var donorNameLabel: UILabel!

    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var numberCommentsLabel: UILabel!
    @IBOutlet weak var donorTimeLabel: UILabel!
    @IBOutlet weak var bottomDetailView: UIView!
    
    @IBOutlet weak var topDetailView: UIView!
    // MARK: - IBOutlets for Style
    @IBOutlet weak var donationLabelView: UILabel!

    @IBOutlet weak var transparentProjectView: TransparentProjectView!
    
    public var detailCallback: ((_ donation: Donation) -> Void)?
    public var profileCallback: ((_ donation: Donation) -> Void)?
    public var donation: Donation!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        self.donorLogoImageView.backgroundColor = .white
        self.donorTimeLabel.textColor = timeGray
        self.donationLabelView.text = "SHOW_IMAGE_DETAIL".localized
        
        self.donorLogoImageView.isUserInteractionEnabled = true
        
        let detailTap = UITapGestureRecognizer(target: self, action: #selector(handleDetailViewTapped))
        self.bottomDetailView.addGestureRecognizer(detailTap)
        
        let topViewTap = UITapGestureRecognizer(target: self, action: #selector(handleTopViewTapped))
        self.topDetailView.addGestureRecognizer(topViewTap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.donorLogoImageView.layer.cornerRadius = self.donorLogoImageView.frame.size.width/2
        self.donorLogoImageView.clipsToBounds = true
        
        self.transparentProjectView.projects = self.donation.projects
        
        self.selfieImageView.image = donation.selfie
        
        self.donorLogoImageView.image = donation.profile?.profileImage
        self.donorNameLabel.text = donation.profile?.userName
        
        self.donorTimeLabel.text = donation.donationTime
        self.numberCommentsLabel.text = donation.numberOfComments
    }
    
    //:Mark tap handler
    
    func handleDetailViewTapped() {
        self.detailCallback!(self.donation!)
    }
    
    func handleTopViewTapped() {
        self.profileCallback!(self.donation!)
    }

}
