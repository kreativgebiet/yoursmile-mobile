//
//  DonationDescriptionViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationDescriptionViewController: UIViewController, UITextViewDelegate, FBSDKSharingDelegate, UIDocumentInteractionControllerDelegate {
    
    public var selfieImage: UIImage?
    
    @IBOutlet weak var donationSumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var publishLabel: UILabel!
    @IBOutlet weak var instagrammButton: RoundedButton!
    @IBOutlet weak var facebookButton: RoundedButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var finishButton: RoundedButton!
    
    var placeholderLabel: UILabel!
    var loadingScreen: LoadingScreen!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.finishButton.setTitle("BACK_TO_PROJECTS".localized, for: .normal)
        self.finishButton.setTitle("BACK_TO_PROJECTS".localized, for: .selected)
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.titleLabel.text = "THANK_YOU".localized
        
        self.title = "DESCRIPTION".localized
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.containerView.layer.borderColor = customDarkerGray.cgColor
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.cornerRadius = 5
        self.containerView.clipsToBounds = true
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y:  0, width: 100, height: 31)
        button.setTitle("DONATE".localized, for: .normal)
        button.setTitle("DONATE".localized, for: .selected)
        button.titleLabel?.font = UIFont(name: "Gotham-Book", size: 18)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .clear
//        button.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = barButton
        
        self.publishLabel.textColor = navigationBarGray
        
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
        self.descriptionTextField.textContainerInset = UIEdgeInsetsMake(10, 7, 0, 0)
        self.descriptionTextField.text = ""
        
        self.descriptionTextField.setNeedsLayout()
        self.descriptionTextField.layoutIfNeeded()
        
        self.placeholderLabel = UILabel()
        self.placeholderLabel.text = "YOUR_COMMENT".localized
        self.placeholderLabel.font = UIFont(name: "Gotham-Book", size: 14)
        self.placeholderLabel.sizeToFit()
        self.descriptionTextField.addSubview(placeholderLabel)
        self.placeholderLabel.frame.origin = CGPoint(x: 10, y: (self.descriptionTextField.font?.pointSize)! / 2 + 5)
        self.placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        self.placeholderLabel.isHidden = !self.descriptionTextField.text.isEmpty

        self.publishLabel.text = "PUBLISH".localized
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        guard let navController = self.navigationController as? NavigationViewController else {
            return
        }
        
        self.selfieImage = navController.selfie
        
        if let image = self.selfieImage {
            self.selfieImageView.image = image
        } else {
            self.selfieImageView.image = #imageLiteral(resourceName: "handshake-icon")
        }
        
        
        self.donationSumLabel.text = "DONATION_SUM_TEXT".localized.replacingOccurrences(of: "%@", with: "\(Int(navController.sum))")
        self.donationSumLabel.textColor = gray85
        
        //disable back swipe
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    // MARK: - Share Button Action
    
    @IBAction func handleFinishButtonPressed(_ sender: Any) {
        
        guard let navc = self.navigationController as? NavigationViewController else {
            return
        }
        
        navc.selectedPayment = Payment.none
        navc.supportedProjects = []
        navc.selfieContext = SelfieContext.none
        navc.selfie = nil
        navc.sum = 0
        
        navc.popToRootViewController(animated: true)
        navc.isNavigationBarHidden = false
    }
    
    var docController: UIDocumentInteractionController!
    
    @IBAction func handleInstagramShare(_ sender: AnyObject) {
        
        guard let image = self.selfieImage else {
            return
        }
        
        let instagramURL = NSURL(string: "instagram://app")!
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            
            
            let filePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("InstagramImage.igo")
            let overlayImage = image.addOverlay()
            let imageData = UIImageJPEGRepresentation(overlayImage.resizeImageTo(maxWidth: 600, maxHeight: 600), 1.0)
            
            do {
                try imageData?.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                let imageURL = NSURL.fileURL(withPath: filePath)
                docController  = UIDocumentInteractionController(url: imageURL)
                docController.delegate = self
                docController.uti = "com.instagram.exclusivegram"                
                docController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
            } catch {
                print(error)
            }
            
        } else {
            HelperFunctions.presentAlertViewfor(error: "INSTAGRAM_ERROR".localized)
        }
        
    }
    
    @IBAction func handleFacebookShare(_ sender: AnyObject) {
                
        loadingScreen = LoadingScreen.init(frame: self.view.bounds)
        
        self.view.endEditing(true)
        self.view.addSubview(loadingScreen)
        let token = FBSDKAccessToken.current()
        
        if token != nil && token?.hasGranted("publish_actions") == true {
            let content = self.createFBSharePhotoContent()
            FBSDKShareAPI.share(with: content, delegate: self)
        } else {
            let loginmanager = FBSDKLoginManager()
            
            loginmanager.logIn(withPublishPermissions: ["publish_actions"], from: self, handler: { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
                
                if ((error) != nil) {
                    HelperFunctions.presentAlertViewfor(error: (error?.localizedDescription)!)
                    self.loadingScreen.removeFromSuperview()
                } else {
                    let content = self.createFBSharePhotoContent()
                    FBSDKShareAPI.share(with: content, delegate: self)
                }
                
            })
            
        }
        
    }
    
    func createFBSharePhotoContent() -> FBSDKSharePhotoContent {
        let sharePhoto = FBSDKSharePhoto.init()
        sharePhoto.image = self.selfieImage?.addOverlay()
        sharePhoto.isUserGenerated = true
        sharePhoto.caption = self.descriptionTextField.text + " " + hastTag + " " + instagramURL + " " + websiteURL
        
        let content = FBSDKSharePhotoContent.init()
        content.photos = [sharePhoto]
        
        return content
    }
    
    // MARK: - FBSDK Share Delegates
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        self.loadingScreen.removeFromSuperview()
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        self.loadingScreen.removeFromSuperview()
        HelperFunctions.presentAlertViewfor(error: (error?.localizedDescription)!)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        self.loadingScreen.removeFromSuperview()
    }
    
    // MARK: - UIDocumentInteractionController delegates
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
