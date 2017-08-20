//
//  FeedCollectionViewCell.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.06.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import Foundation

class FeedCollectionViewCell: UICollectionViewCell {
    
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
    @IBOutlet weak var likesTapView: UIView!
    @IBOutlet weak var profileTapView: UIView!
    
    public var detailCallback: ((_ donation: Upload) -> Void)?
    public var profileCallback: ((_ donation: Upload) -> Void)?
    public var likeCallback: ((_ donation: Upload) -> Void)?
    public var projectCallback: ((_ project: Project) -> Void)?
    public var donation: Upload!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.donorLogoImageView.backgroundColor = .white
        self.donorTimeLabel.textColor = timeGray
        self.profileTapView.backgroundColor = .clear
        
        self.donorLogoImageView.isUserInteractionEnabled = true
        self.selfieImageView.isUserInteractionEnabled = true
        
        let detailTap = UITapGestureRecognizer(target: self, action: #selector(handleDetailViewTapped))
        self.profileTapView.addGestureRecognizer(detailTap)
        
        let topViewTap = UITapGestureRecognizer(target: self, action: #selector(handleTopViewTapped))
        self.topDetailView.addGestureRecognizer(topViewTap)
        
        let selfieImageTap = UITapGestureRecognizer(target: self, action: #selector(handleLikeViewTapped))
        selfieImageTap.numberOfTapsRequired = 2
        self.selfieImageView.addGestureRecognizer(selfieImageTap)
        
        let likeViewTap = UITapGestureRecognizer(target: self, action: #selector(handleLikeViewTapped))
        self.likesTapView.addGestureRecognizer(likeViewTap)
        self.likesImageView.isUserInteractionEnabled = true
        
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
        self.selfieImageView.clipsToBounds = true
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
        
        self.likesLabel.text = donation.numberOfLikes
        self.likesLabel.textColor = (self.donation.userLiked! ? orange : timeGray)
        self.likesImageView.image = (self.donation.userLiked! ? #imageLiteral(resourceName: "like-activ") : #imageLiteral(resourceName: "like"))
    }
    
    //:Mark tap handler
    
    func handleDetailViewTapped() {
        self.detailCallback!(self.donation!)
    }
    
    func handleTopViewTapped() {
        self.profileCallback!(self.donation!)
    }
    
    func handleLikeViewTapped() {
        
        let likeImageView = UIImageView.init(image: #imageLiteral(resourceName: "like-logo"))
        self.selfieImageView.addSubview(likeImageView)
        likeImageView.center = CGPoint(x: self.selfieImageView.center.x, y: self.selfieImageView.center.y - self.transparentProjectView.frame.height)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
            likeImageView.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        }) { (completed) in
            likeImageView.alpha = 0
            likeImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            likeImageView.removeFromSuperview()
            
            if !(self.donation.userLiked!) {
                let numberOfLikes = Int(self.donation.numberOfLikes!)!
                self.handleLike(numberOfLikes+1)
            }
            
        }
        
    }
    
    func handleDislikeTap() {
        
        if self.donation.userLiked! {
            let numberOfLikes = Int(self.donation.numberOfLikes!)!
            self.handleLike(numberOfLikes-1)
        }
        
    }
    
    func handleLike(_ numberOfLikes: Int) {
        let isLiked = !(self.donation.userLiked!)
        
        self.likesImageView.image = (isLiked ? #imageLiteral(resourceName: "like-activ") : #imageLiteral(resourceName: "like"))
        self.likesLabel.text = String(numberOfLikes)
        self.donation.numberOfLikes = String(numberOfLikes)
        
        self.donation.userLiked = isLiked
        self.likeCallback!(self.donation!)
    }
    
}