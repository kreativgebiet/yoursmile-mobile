//
//  ProjectDetailViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController {
    public var project: Project!
    
    @IBOutlet weak var projectsLabel: UILabel!
    @IBOutlet weak var projectLogoImageView: UIImageView!
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var supportButton: RoundedButton!
    @IBOutlet weak var projectDescriptionLabel: UILabel!
    
    public var supportCallback: (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.projectLogoImageView.layer.cornerRadius = self.projectLogoImageView.frame.width/2
        self.projectLogoImageView.clipsToBounds = true
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let bookFont = [NSFontAttributeName: UIFont(name: "Gotham-Book", size: 14.0)!, NSForegroundColorAttributeName: gray156]
        let attrString = NSMutableAttributedString(string: (project?.projectDescription)!, attributes: bookFont)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.projectDescriptionLabel.attributedText = attrString
        
        let imageUrl = URL(string: project.imageURL)!
        self.projectImageView.af_setImage(withURL: imageUrl)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        self.view.addGestureRecognizer(swipeGesture)
        
        self.projectsLabel.text = project.projectName
        
        guard let logoURL = URL(string: project.logoURL) else {
            return
        }
        
        self.projectLogoImageView.af_setImage(withURL: logoURL)
    }
    
    func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Localization
        self.title = "PROJECT_DETAILS".localized
        self.supportButton.setTitle("SUPPORT".localized, for: .normal)
        self.supportButton.setTitle("SUPPORT".localized, for: .selected)
    }

    @IBAction func supportButtonTapped(_ sender: AnyObject) {
        self.supportCallback()
    }

}
