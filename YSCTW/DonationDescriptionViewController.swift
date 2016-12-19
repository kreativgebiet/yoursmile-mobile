//
//  DonationDescriptionViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationDescriptionViewController: UIViewController, UITextViewDelegate, FBSDKSharingDelegate, UIDocumentInteractionControllerDelegate {
    
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
    @IBOutlet weak var containerView: UIView!
    
    var placeholderLabel: UILabel!
    var loadingScreen: LoadingScreen!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DESCRIPTION".localized
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.view.backgroundColor = customLightGray
        
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
        self.placeholderLabel.font = UIFont(name: "Gotham-Book", size: 14)
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
        self.selfieImageView.contentMode = .scaleAspectFill
        
        var text = "DONATION_INFO".localized.replacingOccurrences(of: "%@", with: String(self.projects.count))
        text = text.replacingOccurrences(of: "%1", with: (self.projects.count > 1 ? "PROJECTS_WORD".localized : "PROJECT_WORD".localized))
        self.projectsDonationInfoLabel.text = text
        
        let fee = FeeCalculator.calculateFeeForPaymentAmount(amount: Float(self.projects.count), paymentType: self.payment)
        self.feeLabel.text = "FEE_INFO".localized.replacingOccurrences(of: "%@", with: String(fee))
    }
    
    func proceedTapped() {
        
        let callback: ((_ uploadModel: UploadModel?, _ success: Bool, _ error: String) -> ()) = { (uploadModel, success, error) in

            let description = (self.descriptionTextField.text.characters.count > 0 ? self.descriptionTextField.text : "")
            uploadModel?.image = UIImageJPEGRepresentation(self.selfieImage, 0.5)! as Data?
            uploadModel?.descriptionText = description
            
            let projectIds = self.projects.map({ Int($0.id)! })
            uploadModel?.projectIds = projectIds
            
            do {
                try uploadModel?.managedObjectContext?.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            self.handleDonationSuccess()
        }
        
        if self.payment == .payPal {
            
            let fee = FeeCalculator.calculateFeeForPaymentAmount(amount: Float(self.projects.count), paymentType: self.payment)
            
            let paymentViewController = PayPalViewController()
            paymentViewController.callback = callback
            
            self.present(paymentViewController, animated: false, completion: nil)
            paymentViewController.showPayPalPaymentFor(amount: Float(self.projects.count),fee: fee, projects: self.projects)
            
        } else if self.payment == .creditCard {
            
            let fee = FeeCalculator.calculateFeeForPaymentAmount(amount: Float(self.projects.count), paymentType: self.payment)
            
            let total = Int(fee*100) + self.projects.count * 100
            
            let paymentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StripePaymentViewController") as!  StripePaymentViewController

            paymentViewController.callback = callback
            paymentViewController.totalPrice = total

            self.navigationController?.pushViewController(paymentViewController, animated: true)
            
        } else {
            print("ERROR")
        }
        
    }
    
    func uploadSelfie() {
        APIClient.uploadSelfies()
    }
    
    func handleDonationSuccess() {
        
        self.uploadSelfie()
        
        self.view.endEditing(true)
        
        let navigationView = self.navigationController?.view
        let overlay2 = DonationSuccessOverlay(frame: (navigationView?.bounds)!)
        navigationView?.addSubview(overlay2)
        
        overlay2.callback = {
            overlay2.removeFromSuperview()
            _ = self.navigationController?.popToRootViewController(animated: false)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: feedNotificationIdentifier), object: nil)
        }
    }
    
    // MARK: - Share Button Action
    
    var docController: UIDocumentInteractionController!
    
    @IBAction func handleInstagramShare(_ sender: AnyObject) {
        
        let instagramURL = NSURL(string: "instagram://app")!
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            
            let filePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("InstagramImage.igo")
            let imageData = UIImageJPEGRepresentation(self.selfieImage.resizeImageTo(maxWidth: 600, maxHeight: 600), 1.0)
            
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
            HelperFunctions.presentAlertViewfor(error: "INSTAGRAM_ERROR".localized, presenter: self)
        }
        
    }
    
    @IBAction func handleFacebookShare(_ sender: AnyObject) {
        
        loadingScreen = LoadingScreen.init(frame: self.view.bounds)
        
        self.view.endEditing(true)
        self.view.addSubview(loadingScreen)
        
        if FBSDKAccessToken.current().hasGranted("publish_actions") {
            let content = self.createFBSharePhotoContent()
            FBSDKShareAPI.share(with: content, delegate: self)
        } else {
            let loginmanager = FBSDKLoginManager()
            
            loginmanager.logIn(withPublishPermissions: ["publish_actions"], from: self, handler: { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
                
                if ((error) != nil) {
                    HelperFunctions.presentAlertViewfor(error: (error?.localizedDescription)! , presenter: self)
                } else {
                    let content = self.createFBSharePhotoContent()
                    FBSDKShareAPI.share(with: content, delegate: self)
                }
                
            })
            
        }
        
    }
    
    func createFBSharePhotoContent() -> FBSDKSharePhotoContent {
        let sharePhoto = FBSDKSharePhoto.init()
        sharePhoto.image = self.selfieImage
        sharePhoto.isUserGenerated = true
        sharePhoto.caption = self.descriptionTextField.text
        
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
        HelperFunctions.presentAlertViewfor(error: (error?.localizedDescription)! , presenter: self)
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
