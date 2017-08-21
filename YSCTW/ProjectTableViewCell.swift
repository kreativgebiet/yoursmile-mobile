//
//  ProjectsTableViewCell.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailButton: RoundedButton!
    @IBOutlet weak var supportButton: RoundedButton!
    
    @IBOutlet weak var projectLogoImageView: UIImageView!
    @IBOutlet weak var projectImageView: UIImageView!
    
    @IBOutlet weak var projectLabel: UILabel!
    
    public var project: Project!
    
    public var detailCallback: ((_ project: Project) -> Void)!
    public var supportCallback: ((_ project: Project) -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionLabel.textColor = spacerGray
        self.detailButton.backgroundColor = customGray
        self.detailButton.setTitleColor(navigationBarGray, for: .normal)
        
        contentView.layer.cornerRadius = 4
        contentView.layer.borderColor = gray221.cgColor
        contentView.layer.borderWidth = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let f = contentView.frame
        let fr = UIEdgeInsetsInsetRect(f, UIEdgeInsetsMake(20, 20, 20, 20))
        contentView.frame = fr
        
        self.projectImageView.clipsToBounds = true
        self.contentView.clipsToBounds = true
        
        self.projectLogoImageView.layer.cornerRadius = self.projectLogoImageView.frame.width/2
        self.projectLogoImageView.clipsToBounds = true
        
        //Localization
        self.detailButton.setTitle("SHOW_DETAILS".localized, for: .normal)
        self.detailButton.setTitle("SHOW_DETAILS".localized, for: .selected)
        
        self.supportButton.setTitle("SUPPORT".localized, for: .normal)
        self.supportButton.setTitle("SUPPORT".localized, for: .selected)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let attrString = NSMutableAttributedString(string: (project?.projectDescription)!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        self.descriptionLabel.attributedText = attrString
        
        self.projectLabel.text = project.projectName
        
        guard let url = URL(string: project.imageURL) else {
            return
        }
        
        self.projectImageView.af_setImage(withURL: url)
        
        guard let logoURL = URL(string: project.logoURL) else {
            return
        }
        
        self.projectLogoImageView.af_setImage(withURL: logoURL)
    }
    
    @IBAction func handleDetailButtonTapped(_ sender: AnyObject) {
        self.detailCallback(self.project)
    }
    @IBAction func handleSupportButtonTapped(_ sender: AnyObject) {
        self.supportCallback(self.project)
    }
}
