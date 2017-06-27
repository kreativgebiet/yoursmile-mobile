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
    
    @IBOutlet weak var categoryInfoView: ProjectInfoView!
    @IBOutlet weak var countryInfoView: ProjectInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryInfoView.textLabel.text = self.project.sector
        self.countryInfoView.textLabel.text = self.project.country
        
        self.categoryInfoView.iconImageView.image = #imageLiteral(resourceName: "filter-icon")
        self.countryInfoView.iconImageView.image = #imageLiteral(resourceName: "world-icon")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let mediumFont = [NSFontAttributeName: UIFont(name: "Gotham-Medium", size: 14.0)!]
        let bookFont = [NSFontAttributeName: UIFont(name: "Gotham-Book", size: 14.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: (project?.projectName)! + "\n\n", attributes: mediumFont)
        titleAttrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, titleAttrString.length))
        
        let attrString = NSMutableAttributedString(string: (project?.projectDescription)!, attributes: bookFont)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        let combination = NSMutableAttributedString()
        combination.append(titleAttrString)
        combination.append(attrString)
        
        self.projectDescriptionLabel.attributedText = combination
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
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            _ = self.navigationController?.popViewController(animated: true)
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
