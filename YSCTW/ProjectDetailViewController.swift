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
    
    @IBOutlet weak var progressView: ProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PROJECT".localized
        
        self.projectDescriptionLabel.text = self.project.projectDescription
        self.projectImageView.image = self.project.projectImage
        
        self.transparentProjectView.projects.append(self.project)
        
        //Localization
        self.supportButton.setTitle("SUPPORT".localized, for: .normal)
        self.supportButton.setTitle("SUPPORT".localized, for: .selected)
        
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

    @IBAction func supportButtonTapped(_ sender: AnyObject) {
        self.navigationController?.performSegue(withIdentifier: "cameraSegue", sender: self.project)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
