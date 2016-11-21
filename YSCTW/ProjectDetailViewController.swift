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
        
        self.projectDescriptionLabel.text = self.project.projectDescription
        self.projectImageView.image = self.project.projectImage
        
        self.transparentProjectView.projects.append(self.project)
        
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
