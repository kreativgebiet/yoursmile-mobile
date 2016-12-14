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
    
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var supportButton: RoundedButton!
    @IBOutlet weak var projectDescriptionLabel: UILabel!
    @IBOutlet weak var transparentProjectView: TransparentProjectView!
    
    public var supportCallback: (() -> Void)!
    
    @IBOutlet weak var progressView: ProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let attrString = NSMutableAttributedString(string: (project?.projectDescription)!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        self.projectDescriptionLabel.attributedText = attrString
        let imageUrl = URL(string: project.imageURL)!
        self.projectImageView.af_setImage(withURL: imageUrl)
        
        self.transparentProjectView.projects.append(self.project)
        
        self.progressView.progress = (Float(self.project.progress)/100.0).roundTo(places: 2)
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.transparentProjectView.transparentView.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.85
            blurEffectView.frame = self.transparentProjectView.bounds
            
            self.transparentProjectView.insertSubview(blurEffectView, at: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Localization
        self.title = "PROJECT".localized
        self.supportButton.setTitle("SUPPORT".localized, for: .normal)
        self.supportButton.setTitle("SUPPORT".localized, for: .selected)
    }

    @IBAction func supportButtonTapped(_ sender: AnyObject) {
        self.supportCallback()
    }

}
