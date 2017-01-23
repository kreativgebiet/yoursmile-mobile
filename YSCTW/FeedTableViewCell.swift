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
    
    public var detailCallback: ((_ donation: Upload) -> Void)?
    public var profileCallback: ((_ donation: Upload) -> Void)?
    public var projectCallback: ((_ project: Project) -> Void)?
    public var donation: Upload!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        self.donorLogoImageView.backgroundColor = .white
        self.donorTimeLabel.textColor = timeGray
        
        self.donorLogoImageView.isUserInteractionEnabled = true
        
        let detailTap = UITapGestureRecognizer(target: self, action: #selector(handleDetailViewTapped))
        self.bottomDetailView.addGestureRecognizer(detailTap)
        
        let topViewTap = UITapGestureRecognizer(target: self, action: #selector(handleTopViewTapped))
        self.topDetailView.addGestureRecognizer(topViewTap)
        
        self.transparentProjectView.callback = { (project: Project) in
            if self.projectCallback != nil {
                self.projectCallback!(project)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.donationLabelView.text = "SHOW_IMAGE_DETAIL".localized
        
        self.donorLogoImageView.layer.cornerRadius = self.donorLogoImageView.frame.size.width/2
        self.donorLogoImageView.clipsToBounds = true
        
        self.transparentProjectView.projects = self.donation.projects
        self.transparentProjectView.setNeedsLayout()
        self.transparentProjectView.layoutIfNeeded()
        
        self.selfieImageView.image = nil
        let imageURL = URL(string: self.donation.imageURL)!
        self.selfieImageView.af_setImage(withURL: imageURL)
        
        if (donation.profile?.avatarUrl.characters.count)! > 0 {
            let imageURL = URL(string: (donation.profile?.avatarUrl)!)!
            self.donorLogoImageView.af_setImage(withURL: imageURL)
        } else {
            self.donorLogoImageView.image = #imageLiteral(resourceName: "user-icon")
        }
        
        self.donorNameLabel.text = donation.profile?.name
        
        self.donorTimeLabel.text = donation.date.offset(from: Date())
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
