//
//  ProjectsTableViewCell.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailButton: RoundedButton!
    @IBOutlet weak var supportButton: RoundedButton!
    @IBOutlet weak var transparentProjectView: TransparentProjectView!

    
    public var project: Project!
    
    public var detailCallback: ((_ project: Project) -> Void)!
    public var supportCallback: ((_ project: Project) -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionLabel.textColor = spacerGray
        self.detailButton.backgroundColor = customGray
        self.detailButton.setTitleColor(navigationBarGray, for: .normal)
        
        //Localization
        self.detailButton.setTitle("SHOW_DETAILS".localized, for: .normal)
        self.detailButton.setTitle("SHOW_DETAILS".localized, for: .selected)
        
        self.supportButton.setTitle("SUPPORT".localized, for: .normal)
        self.supportButton.setTitle("SUPPORT".localized, for: .selected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.projectImageView.image = project?.projectImage
        self.descriptionLabel.text = project?.projectDescription
        self.transparentProjectView.projects.append(self.project)
    }
    
    @IBAction func handleDetailButtonTapped(_ sender: AnyObject) {
        self.detailCallback(self.project)
    }
    @IBAction func handleSupportButtonTapped(_ sender: AnyObject) {
        self.supportCallback(self.project)
    }
}
