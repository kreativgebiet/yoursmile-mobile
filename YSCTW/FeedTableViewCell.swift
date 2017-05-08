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
    @IBOutlet weak var transparentProjectView: TransparentProjectView!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    
    public var detailCallback: ((_ donation: Upload) -> Void)?
    public var profileCallback: ((_ donation: Upload) -> Void)?
    public var likeCallback: ((_ donation: Upload) -> Void)?
    public var projectCallback: ((_ project: Project) -> Void)?
    public var donation: Upload!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        self.donorLogoImageView.backgroundColor = .white
        self.donorTimeLabel.textColor = timeGray
        
        self.likesImageView.image = #imageLiteral(resourceName: "like")
        
        self.donorLogoImageView.isUserInteractionEnabled = true
        self.selfieImageView.isUserInteractionEnabled = true
        
        let detailTap = UITapGestureRecognizer(target: self, action: #selector(handleDetailViewTapped))
        self.bottomDetailView.addGestureRecognizer(detailTap)
        
        let topViewTap = UITapGestureRecognizer(target: self, action: #selector(handleTopViewTapped))
        self.topDetailView.addGestureRecognizer(topViewTap)
        
        let selfieImageTap = UITapGestureRecognizer(target: self, action: #selector(handleLikeViewTapped))
        selfieImageTap.numberOfTapsRequired = 2
        self.selfieImageView.addGestureRecognizer(selfieImageTap)
        
        self.transparentProjectView.callback = { (project: Project) in
            if self.projectCallback != nil {
                self.projectCallback!(project)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
    
    func handleLikeViewTapped() {
        
        // WARNING: todo
        
        let likeImageView = UIImageView.init(image: #imageLiteral(resourceName: "like-logo"))
        self.selfieImageView.addSubview(likeImageView)
        likeImageView.center = CGPoint(x: self.selfieImageView.center.x, y: self.selfieImageView.center.y - self.transparentProjectView.frame.height)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
            likeImageView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }) { (completed) in
            likeImageView.alpha = 0
            likeImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            likeImageView.removeFromSuperview()
            self.likesImageView.image = #imageLiteral(resourceName: "like-activ")
            self.likesLabel.textColor = orange
        }
        
        self.likeCallback!(self.donation!)
    }

}
