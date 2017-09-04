//
//  DonationDetailViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationDetailViewController: UIViewController, FBSDKSharingDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var commentView: CommentView!
    @IBOutlet weak var commentViewBottomSpaceConstraint: NSLayoutConstraint!
    
    public var donation: Upload?
    public var dataManager: DataManager?
    
    var loadingScreen: LoadingScreen!
    
    var donationDetailTableViewController: DonationDetailTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentView.callback = { text in
            let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
            self.view.addSubview(loadingScreen)
            
            self.dataManager?.postCommentWith((self.donation?.id)!, text, { (comments) in
                self.donationDetailTableViewController.comments?.append(contentsOf: comments)
                self.donationDetailTableViewController.reloadData()
                self.commentView.commentTextField.text = ""
                self.commentView.endEditing(true)
                
                loadingScreen.removeFromSuperview()
            })
        }
        
        self.dataManager?.commentsWith((donation?.id)!, { (comments) in
            self.donationDetailTableViewController.comments = comments
            self.donationDetailTableViewController.reloadData()
        })
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y:  0, width: 51, height: 31)
        button.setImage(#imageLiteral(resourceName: "more-icon"), for: .normal)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        button.transform = CGAffineTransform(translationX: 15, y: 3)
        
        let containerView = UIView()
        containerView.frame = button.frame
        containerView.addSubview(button)
        
        let barButton = UIBarButtonItem()
        barButton.customView = containerView
        barButton.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = barButton
        
        self.navigationItem.rightBarButtonItem?.setBackgroundVerticalPositionAdjustment(10, for: UIBarMetrics.default)
                
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Bar button handling
    
    func addTapped() {
        self.view.endEditing(true)
        let navigationView = self.navigationController?.view
        let overlay = DonationDetailOverlayView(frame: (navigationView?.bounds)!)
        
        overlay.facebookCallback = {
            overlay.removeFromSuperview()
            self.shareOnFacebook()
        }
        
        overlay.instagramCallback = {
            overlay.removeFromSuperview()
            self.shareOnInstagram()
        }
        
        overlay.reportCallback = {
            
            let loadingScreen = LoadingScreen(frame: (self.navigationController?.view.bounds)!)
            self.navigationController?.view.addSubview(loadingScreen)
            
            self.dataManager?.reportUpload(Int((self.donation?.id)!)!, { (success, errorMessage) in
                
                loadingScreen.removeFromSuperview()
                overlay.removeFromSuperview()
                
                if success {
                    HelperFunctions.presentAlertViewfor(information: "UPLOAD_REPORTED".localized, presenter: (self.navigationController)!)
                }
                
            })
        }
        
        navigationView?.addSubview(overlay)
    }

    // MARK: - Keyboard animations
    
    func animateWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let moveUp = (notification.name == NSNotification.Name.UIKeyboardWillShow)        
        
        self.commentViewBottomSpaceConstraint.constant = moveUp ? (keyboardSize?.height)! : 0
        
        let options = UIViewAnimationOptions(rawValue: curve << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options,
                       animations: {
                        self.view.layoutIfNeeded()
            },
                       completion: nil
        )
    }
    
    // MARK: - Instagram Share
    
    var docController: UIDocumentInteractionController!
    
    func shareOnInstagram() {
        let instagramURL = NSURL(string: "instagram://app")!
        if UIApplication.shared.canOpenURL(instagramURL as URL) {
            
            let image = self.donationDetailTableViewController.donationHeaderView.selfieImageView.image?.addOverlay()
            let filePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("InstagramImage.igo")
            let imageData = UIImageJPEGRepresentation((image?.resizeImageTo(maxWidth: 600, maxHeight: 600))!, 1.0)
            
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
    
    // MARK: - UIDocumentInteractionController delegates
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        
    }
    
    // MARK: - FB Share
    
    func shareOnFacebook() {
        
        self.loadingScreen = LoadingScreen.init(frame: self.view.bounds)

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
                } else {
                    let content = self.createFBSharePhotoContent()
                    FBSDKShareAPI.share(with: content, delegate: self)
                }
    
            })
    
        }
    }
    
    func createFBSharePhotoContent() -> FBSDKSharePhotoContent {
        let sharePhoto = FBSDKSharePhoto.init()
        
        let overlayImage = self.donationDetailTableViewController.donationHeaderView.selfieImageView.image?.addOverlay()
                
        sharePhoto.image = overlayImage
        sharePhoto.isUserGenerated = true
        var caption = (self.donation?.description)! + " " + hashTag
        caption = caption + " " + instagramURL + " " + websiteURL
        sharePhoto.caption = caption
        
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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "donationDetailTableVCSegue" {
            self.donationDetailTableViewController = segue.destination as! DonationDetailTableViewController
            self.donationDetailTableViewController.donation = self.donation
        }
        
    } 
}
