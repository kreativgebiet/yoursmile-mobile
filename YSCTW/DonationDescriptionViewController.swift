//
//  DonationDescriptionViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationDescriptionViewController: UIViewController, UITextViewDelegate {
    
    public var projects: [Project]!
    public var selfieImage: UIImage!
    public var payment: Payment!
    
    @IBOutlet weak var projectsLogoView: DonationDescriptionLogoView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var publishLabel: UILabel!
    @IBOutlet weak var instagrammButton: RoundedButton!
    @IBOutlet weak var facebookButton: RoundedButton!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var projectsDonationInfoLabel: UILabel!
    
    var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DESCRIPTION".localized
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.view.backgroundColor = customLightGray
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y:  0, width: 100, height: 31)
        button.setTitle("DONATE".localized, for: .normal)
        button.setTitle("DONATE".localized, for: .selected)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(orange, for: .normal)
        button.setTitleColor(orange, for: .selected)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = barButton
        
        self.projectsDonationInfoLabel.textColor = navigationBarGray
        self.publishLabel.textColor = navigationBarGray
        self.feeLabel.textColor = spacerGray
        
        self.instagrammButton.backgroundColor = .white
        self.facebookButton.backgroundColor = .white
        
        self.instagrammButton.layer.borderColor = customGray.cgColor
        self.instagrammButton.layer.borderWidth = 1
        self.instagrammButton.setTitleColor(navigationBarGray, for: .normal)
        self.instagrammButton.setTitleColor(navigationBarGray, for: .selected)
        
        self.instagrammButton.imageEdgeInsets = UIEdgeInsetsMake(10, -10, 10, 0)
        self.instagrammButton.imageView?.contentMode = .scaleAspectFit
        
        self.facebookButton.layer.borderColor = customGray.cgColor
        self.facebookButton.layer.borderWidth = 1
        self.facebookButton.setTitleColor(navigationBarGray, for: .normal)
        self.facebookButton.setTitleColor(navigationBarGray, for: .selected)
        
        self.facebookButton.imageEdgeInsets = UIEdgeInsetsMake(10, -10, 10, 0)
        self.facebookButton.imageView?.contentMode = .scaleAspectFit
        
        self.descriptionTextField.delegate = self
        self.descriptionTextField.text = ""
        
        self.placeholderLabel = UILabel()
        self.placeholderLabel.text = "YOUR_COMMENT".localized
        self.placeholderLabel.font = UIFont.systemFont(ofSize: (self.descriptionTextField.font?.pointSize)!)
        self.placeholderLabel.sizeToFit()
        self.descriptionTextField.addSubview(placeholderLabel)
        self.placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.descriptionTextField.font?.pointSize)! / 2)
        self.placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        self.placeholderLabel.isHidden = !self.descriptionTextField.text.isEmpty

        self.publishLabel.text = "PUBLISH".localized
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.projectsLogoView.projects = self.projects
        
        self.projectsLogoView.setNeedsLayout()
        self.projectsLogoView.layoutIfNeeded()
        
        self.selfieImageView.image = self.selfieImage
        
        var text = "DONATION_INFO".localized.replacingOccurrences(of: "%@", with: String(self.projects.count))
        text = text.replacingOccurrences(of: "%1", with: (self.projects.count > 1 ? "PROJECTS_WORD".localized : "PROJECT_WORD".localized))
        self.projectsDonationInfoLabel.text = text
        
        self.feeLabel.text = "FEE_INFO".localized.replacingOccurrences(of: "%@", with: "100")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func proceedTapped() {
        let navigationView = self.navigationController?.view
        let overlay = DonationFeeOverlayView(frame: (navigationView?.bounds)!)
        navigationView?.addSubview(overlay)
        
        overlay.callback = {
            overlay.removeFromSuperview()
            
            let navigationView = self.navigationController?.view
            let overlay2 = DonationSuccessOverlay(frame: (navigationView?.bounds)!)
            navigationView?.addSubview(overlay2)
            
            overlay2.callback = {
                overlay2.removeFromSuperview()
                _ = self.navigationController?.popToRootViewController(animated: false)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: feedNotificationIdentifier), object: nil)
            }
            
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
